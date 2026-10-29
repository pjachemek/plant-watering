import 'dart:async';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/sync/live_updates.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';

import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_household_repository.dart';
import '../../helpers/pump_app.dart';

class FakeSocket implements LiveSocket {
  final StreamController<String> server = StreamController<String>();
  final List<String> sent = [];
  bool closedByApp = false;

  @override
  int? closeCode;

  @override
  Stream<String> get messages => server.stream;

  @override
  void send(String text) => sent.add(text);

  @override
  Future<void> close() async {
    closedByApp = true;
    closeCode = 1000;
    await server.close();
  }

  /// The server closes the socket with [code].
  void closeWith(int code) {
    closeCode = code;
    unawaited(server.close());
  }
}

class FakeTransport implements LiveTransport {
  final List<({Uri url, Map<String, String> headers})> connects = [];
  final List<FakeSocket> sockets = [];
  bool fail = false;

  FakeSocket get last => sockets.last;

  @override
  Future<LiveSocket> connect(Uri url, Map<String, String> headers) async {
    connects.add((url: url, headers: headers));
    if (fail) throw const SocketExceptionStub();
    final socket = FakeSocket();
    sockets.add(socket);
    return socket;
  }
}

class SocketExceptionStub implements Exception {
  const new();
}

void main() {
  late FakeAuthRepository auth;
  late FakeHouseholdRepository households;
  late FakeTransport transport;
  late int syncs;

  ProviderContainer start() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        appConfigProvider.overrideWithValue(testConfig),
        householdRepositoryProvider.overrideWithValue(households),
        liveTransportProvider.overrideWithValue(transport),
        syncRunnerProvider.overrideWithValue((_) async {
          syncs++;
          return null;
        }),
        outboxSizeProvider.overrideWith((ref) => const Stream<int>.empty()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(liveUpdatesProvider, (_, _) {});
    return container;
  }

  setUp(() {
    auth = FakeAuthRepository();
    households = FakeHouseholdRepository();
    transport = FakeTransport();
    syncs = 0;
  });

  test('reconnect delays: 1 s doubling to 60 s, with jitter', () {
    final r = Random(1);
    expect(
      LiveUpdates.backoff(1, r).inMilliseconds,
      inInclusiveRange(800, 1200),
    );
    expect(
      LiveUpdates.backoff(4, r).inMilliseconds,
      inInclusiveRange(6400, 9600),
    );
    expect(LiveUpdates.backoff(30, r).inSeconds, inInclusiveRange(48, 72));
  });

  test('connects to the household channel with version headers and token', () {
    fakeAsync((time) {
      final container = start();
      time.flushMicrotasks();

      final connect = transport.connects.single;
      expect(
        connect.url.toString(),
        'ws://api.localhost/v1/live?household_id=${FakeHouseholdRepository.home.id}',
      );
      expect(connect.headers['Authorization'], 'Bearer test-access-token');
      expect(connect.headers['X-App-Version'], isNotEmpty);
      expect(connect.headers['X-API-Version'], '1');
      expect(container.read(liveUpdatesProvider), LiveStatus.connected);
      time.elapse(const Duration(milliseconds: 500));
      expect(syncs, 1); // catches up on connect
    });
  });

  test('every change signal runs a sync; pongs and unknown types do not', () {
    fakeAsync((time) {
      start();
      time.elapse(const Duration(seconds: 1));
      final socket = transport.last;
      syncs = 0;

      socket.server
        ..add('{"type":"changed","v":1}')
        ..add('pong')
        ..add('{"type":"something-new","v":2}')
        ..add('not json');
      time.elapse(const Duration(seconds: 1));
      expect(syncs, 1);

      socket.server.add('{"type":"changed","v":1}');
      time.elapse(const Duration(seconds: 1));
      expect(syncs, 2);
    });
  });

  test('pings every 30 seconds', () {
    fakeAsync((time) {
      start();
      time.elapse(const Duration(seconds: 61));
      expect(transport.last.sent, ['ping', 'ping']);
    });
  });

  test('reconnects after a drop, backing off while the server is away', () {
    fakeAsync((time) {
      start();
      time.flushMicrotasks();
      transport.fail = true;
      transport.last.closeWith(1006);
      time.elapse(const Duration(milliseconds: 1300)); // first retry ~1 s
      expect(transport.connects, hasLength(2));
      time.elapse(const Duration(milliseconds: 2500)); // then ~2 s
      expect(transport.connects, hasLength(3));

      transport.fail = false;
      time.elapse(const Duration(seconds: 5));
      expect(transport.connects, hasLength(4));
      expect(transport.sockets, hasLength(2));
    });
  });

  test('an expired token is refreshed before reconnecting', () {
    fakeAsync((time) {
      start();
      time.flushMicrotasks();

      transport.last.closeWith(LiveUpdates.tokenExpired);
      time.flushMicrotasks();

      expect(auth.refreshes, 1);
      expect(transport.connects, hasLength(2));
    });
  });

  test('when removed from the household it stops and resyncs', () {
    fakeAsync((time) {
      start();
      time.elapse(const Duration(seconds: 1));
      syncs = 0;

      transport.last.closeWith(LiveUpdates.notMember);
      time.elapse(const Duration(minutes: 5));

      expect(transport.connects, hasLength(1));
      expect(syncs, 1);
    });
  });

  test('closes in the background and reopens on resume', () {
    fakeAsync((time) {
      final container = start();
      time.flushMicrotasks();
      final notifier = container.read(liveUpdatesProvider.notifier)
        ..appPaused();
      time.elapse(const Duration(minutes: 10));
      expect(transport.last.closedByApp, isTrue);
      expect(transport.connects, hasLength(1));
      expect(transport.last.sent, isEmpty); // no pings in the background

      notifier.appResumed();
      time.flushMicrotasks();
      expect(transport.connects, hasLength(2));
    });
  });

  test('no socket while signed out or without a household', () {
    fakeAsync((time) {
      auth = FakeAuthRepository(signedIn: false);
      start();
      time.elapse(const Duration(minutes: 1));
      expect(transport.connects, isEmpty);

      auth.setStatus(const SignedIn(FakeAuthRepository.userId));
      time.flushMicrotasks();
      expect(transport.connects, hasLength(1));

      auth.setStatus(const SignedOut());
      time.flushMicrotasks();
      expect(transport.last.closedByApp, isTrue);
    });

    fakeAsync((time) {
      households = FakeHouseholdRepository(current: null);
      transport = FakeTransport();
      start();
      time.elapse(const Duration(minutes: 1));
      expect(transport.connects, isEmpty);
    });
  });
}
