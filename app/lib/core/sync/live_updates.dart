import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_updates.g.dart';

/// One open live-updates socket.
abstract interface class LiveSocket {
  /// Text frames from the server; done when the socket closes.
  Stream<String> get messages;

  /// Why it closed, once [messages] is done.
  int? get closeCode;

  void send(String text);

  Future<void> close();
}

/// Opens [LiveSocket]s; tests fake it.
abstract interface class LiveTransport {
  Future<LiveSocket> connect(Uri url, Map<String, String> headers);
}

/// `dart:io` WebSockets (no extra package).
class IoLiveTransport implements LiveTransport {
  @override
  Future<LiveSocket> connect(Uri url, Map<String, String> headers) async =>
      _IoLiveSocket(await WebSocket.connect(url.toString(), headers: headers));
}

class _IoLiveSocket implements LiveSocket {
  new(this._socket);

  final WebSocket _socket;

  @override
  Stream<String> get messages =>
      _socket.where((frame) => frame is String).cast<String>();

  @override
  int? get closeCode => _socket.closeCode;

  @override
  void send(String text) => _socket.add(text);

  @override
  Future<void> close() => _socket.close(WebSocketStatus.normalClosure);
}

@Riverpod(keepAlive: true)
LiveTransport liveTransport(Ref ref) => IoLiveTransport();

enum LiveStatus { off, connecting, connected }

/// The live-updates connection (ADR-0013, ADR-0020, ADR-0026): while the app
/// is open, signed in and in a household, one WebSocket to that household's
/// channel. Each "changed" signal runs a sync, so other phones' changes
/// show within seconds (FR-2, NFR Sync). The socket never carries data, and
/// it closes in the background (NFR Battery).
@Riverpod(keepAlive: true)
class LiveUpdates extends _$LiveUpdates {
  /// Keeps idle mobile networks and proxies from dropping the socket. The
  /// server answers without waking the household's object.
  static const Duration pingInterval = Duration(seconds: 30);

  /// Close codes from the server (ADR-0020).
  static const int tokenExpired = 4001;
  static const int notMember = 4003;

  LiveSocket? _socket;
  StreamSubscription<String>? _messages;
  Timer? _ping;
  Timer? _reconnect;
  int _failures = 0;
  bool _foreground = true;
  String? _householdId;

  /// Bumped on every (dis)connect, so a late callback from an old socket is
  /// ignored.
  int _generation = 0;
  final Random _random = Random();

  @override
  LiveStatus build() {
    ref
      ..listen(
        currentHouseholdProvider,
        (_, next) => _setHousehold(next.value?.id),
        fireImmediately: true,
      )
      ..onDispose(_disconnect);
    final auth = ref.watch(authRepositoryProvider);
    final changes = auth.statusChanges.listen((status) {
      if (status is SignedIn) {
        _connectIfWanted();
      } else {
        _disconnect();
      }
    });
    ref.onDispose(changes.cancel);
    return LiveStatus.off;
  }

  /// Reconnect delay after [failures] failed attempts: 1 s doubling to 60 s,
  /// with ±20% jitter.
  static Duration backoff(int failures, [Random? random]) {
    final base = min(pow(2, max(0, failures - 1)), 60).toDouble();
    final jitter = 0.8 + (random ?? Random()).nextDouble() * 0.4;
    return Duration(milliseconds: (base * jitter * 1000).round());
  }

  void appPaused() {
    _foreground = false;
    _disconnect();
  }

  void appResumed() {
    _foreground = true;
    _connectIfWanted();
  }

  void _setHousehold(String? id) {
    if (id == _householdId) return;
    _householdId = id;
    _disconnect();
    _connectIfWanted();
  }

  void _connectIfWanted() {
    if (_socket != null || _reconnect?.isActive == true) return;
    if (!_foreground || _householdId == null) return;
    if (ref.read(authRepositoryProvider).status is! SignedIn) return;
    unawaited(_connect(_householdId!));
  }

  Future<void> _connect(String householdId) async {
    final generation = ++_generation;
    state = LiveStatus.connecting;
    final auth = ref.read(authRepositoryProvider);
    final token = await auth.accessToken();
    if (generation != _generation || token == null) return;
    final api = Uri.parse(ref.read(appConfigProvider).apiBaseUrl);
    final url = api.replace(
      scheme: api.scheme == 'http' ? 'ws' : 'wss',
      path: '${api.path}/live',
      queryParameters: {'household_id': householdId},
    );
    final LiveSocket socket;
    try {
      socket = await ref.read(liveTransportProvider).connect(url, {
        'X-App-Version': appVersion,
        'X-Platform': 'android',
        'X-API-Version': ApiHeadersInterceptor.apiVersion,
        'Authorization': 'Bearer $token',
      });
    } on Object {
      if (generation == _generation) _scheduleReconnect();
      return;
    }
    if (generation != _generation || !ref.mounted) {
      unawaited(socket.close());
      return;
    }
    _socket = socket;
    _failures = 0;
    state = LiveStatus.connected;
    // Catch up on anything missed while not connected.
    _requestSync();
    _ping = Timer.periodic(pingInterval, (_) => socket.send('ping'));
    _messages = socket.messages.listen(
      _onMessage,
      onDone: () => _onClosed(generation, socket.closeCode),
      onError: (Object _) {},
      cancelOnError: false,
    );
  }

  void _onMessage(String text) {
    if (text == 'pong') return;
    try {
      final message = jsonDecode(text);
      // Unknown types (from a newer server) are ignored.
      if (message is Map && message['type'] == 'changed') _requestSync();
    } on FormatException {
      // Not ours.
    }
  }

  Future<void> _onClosed(int generation, int? code) async {
    if (generation != _generation) return;
    _cleanUp();
    if (!_foreground) return;
    switch (code) {
      case notMember:
        // Removed from the household: sync drops it from the phone; the
        // next household (if any) reconnects through _setHousehold.
        _requestSync();
      case tokenExpired:
        await ref.read(authRepositoryProvider).refreshAccessToken();
        _connectIfWanted();
      default:
        _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _cleanUp();
    if (!_foreground) return;
    _failures++;
    _reconnect = Timer(backoff(_failures, _random), _connectIfWanted);
  }

  void _requestSync() =>
      ref.read(syncControllerProvider.notifier).requestSync(soon: true);

  void _cleanUp() {
    _ping?.cancel();
    _ping = null;
    unawaited(_messages?.cancel());
    _messages = null;
    _socket = null;
    if (ref.mounted) state = LiveStatus.off;
  }

  void _disconnect() {
    _generation++;
    _reconnect?.cancel();
    _reconnect = null;
    final socket = _socket;
    _cleanUp();
    if (socket != null) unawaited(socket.close());
  }
}
