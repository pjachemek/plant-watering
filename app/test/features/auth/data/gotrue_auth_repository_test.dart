import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gotrue/gotrue.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/data/google_id_token_source.dart';
import 'package:plantnfc/features/auth/data/gotrue_auth_repository.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

const String userId = '0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e71';

/// An unsigned JWT with an expiry: the client only reads `exp`.
String accessToken({Duration validFor = const Duration(hours: 1)}) {
  String part(Map<String, Object> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final exp = DateTime.now().add(validFor).millisecondsSinceEpoch ~/ 1000;
  return '${part({'alg': 'none'})}.${part({'sub': userId, 'exp': exp})}.sig';
}

Map<String, Object> sessionJson({
  Duration validFor = const Duration(hours: 1),
}) => {
  'access_token': accessToken(validFor: validFor),
  'token_type': 'bearer',
  'expires_in': 3600,
  'refresh_token': 'refresh-1',
  'user': {
    'id': userId,
    'aud': 'authenticated',
    'role': 'authenticated',
    'app_metadata': <String, Object>{},
    'user_metadata': <String, Object>{},
    'created_at': '2026-10-28T12:00:00Z',
  },
};

class MemoryStore extends GotrueAsyncStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> getItem({required String key}) async => values[key];

  @override
  Future<void> setItem({required String key, required String value}) async =>
      values[key] = value;

  @override
  Future<void> removeItem({required String key}) async => values.remove(key);
}

class FakeGoogle implements GoogleIdTokenSource {
  Result<GoogleIdToken, AuthFailure> result = const Success(
    GoogleIdToken(idToken: 'google-id-token', rawNonce: 'raw-nonce'),
  );
  int signOuts = 0;

  /// When set, forgetting the account waits for it, as Android's can.
  Completer<void>? slowSignOut;

  @override
  Future<Result<GoogleIdToken, AuthFailure>> signIn() async => result;

  @override
  Future<void> signOut() async {
    signOuts++;
    await slowSignOut?.future;
  }
}

/// A fake Supabase Auth server: records requests, answers with [respond].
class FakeServer {
  final List<http.Request> requests = [];
  Future<http.Response> Function(http.Request request) respond = (_) async =>
      throw http.ClientException('offline');

  late final MockClient client = MockClient((request) {
    requests.add(request);
    return respond(request);
  });

  static http.Response json(Object body, [int status = 200]) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );

  Map<String, dynamic> bodyOf(int index) =>
      jsonDecode(requests[index].body) as Map<String, dynamic>;
}

void main() {
  late FakeServer server;
  late MemoryStore store;
  late FakeGoogle google;
  late GoTrueAuthRepository repository;

  setUp(() {
    server = FakeServer();
    store = MemoryStore();
    google = FakeGoogle();
    repository = GoTrueAuthRepository(
      client: GoTrueClient(
        url: 'http://auth.test/auth/v1',
        httpClient: server.client,
        autoRefreshToken: false,
      ),
      store: store,
      google: google,
    );
  });

  tearDown(() => repository.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  group('restore', () {
    test('is signed out without a saved session', () async {
      await repository.restore();

      expect(repository.status, const SignedOut());
      expect(server.requests, isEmpty);
    });

    test('signs in from the saved session without the network', () async {
      store.values[GoTrueAuthRepository.sessionKey] = jsonEncode(sessionJson());

      await repository.restore();

      expect(repository.status, const SignedIn(userId));
      expect(server.requests, isEmpty);
      expect(await repository.accessToken(), isNotNull);
    });

    test('forgets a saved session it cannot read', () async {
      store.values[GoTrueAuthRepository.sessionKey] = '{"access_token": 1}';

      await repository.restore();

      expect(repository.status, const SignedOut());
      expect(store.values, isNot(contains(GoTrueAuthRepository.sessionKey)));
    });
  });

  group('Google', () {
    test('trades the ID token and raw nonce for a saved session', () async {
      server.respond = (_) async => FakeServer.json(sessionJson());
      await repository.restore();
      final changes = <AuthStatus>[];
      repository.statusChanges.listen(changes.add);

      final result = await repository.signInWithGoogle();
      await settle();

      expect(result, const Success<void, AuthFailure>(null));
      expect(server.requests.single.url.path, '/auth/v1/token');
      expect(
        server.requests.single.url.queryParameters['grant_type'],
        'id_token',
      );
      expect(server.bodyOf(0), containsPair('provider', 'google'));
      expect(server.bodyOf(0), containsPair('id_token', 'google-id-token'));
      expect(server.bodyOf(0), containsPair('nonce', 'raw-nonce'));
      expect(changes, [const SignedIn(userId)]);
      expect(store.values, contains(GoTrueAuthRepository.sessionKey));
    });

    test('passes on a failure from the account picker', () async {
      google.result = const Failure(AuthFailure.cancelled);

      expect(
        await repository.signInWithGoogle(),
        const Failure<void, AuthFailure>(AuthFailure.cancelled),
      );
      expect(server.requests, isEmpty);
    });

    test('reports a refused token as unknown and stays signed out', () async {
      server.respond = (_) async => FakeServer.json({
        'code': 400,
        'error_code': 'bad_jwt',
        'msg': 'Bad ID token',
      }, 400);
      await repository.restore();

      expect(
        await repository.signInWithGoogle(),
        const Failure<void, AuthFailure>(AuthFailure.unknown),
      );
      expect(repository.status, const SignedOut());
    });
  });

  group('session', () {
    test('refreshes the token on request, or answers null offline', () async {
      store.values[GoTrueAuthRepository.sessionKey] = jsonEncode(sessionJson());
      await repository.restore();
      server.respond = (_) async => FakeServer.json(sessionJson());

      expect(await repository.refreshAccessToken(), isNotNull);
      expect(
        server.requests.single.url.queryParameters['grant_type'],
        'refresh_token',
      );

      server.respond = (_) async => FakeServer.json({
        'code': 400,
        'error_code': 'refresh_token_not_found',
        'msg': 'Invalid Refresh Token',
      }, 400);
      expect(await repository.refreshAccessToken(), isNull);
    });

    test('has no access token when signed out', () async {
      await repository.restore();

      expect(await repository.accessToken(), isNull);
    });

    test('keeps the expired token offline instead of signing out', () async {
      store.values[GoTrueAuthRepository.sessionKey] = jsonEncode(
        sessionJson(validFor: const Duration(minutes: -5)),
      );
      final client = GoTrueClient(
        url: 'http://auth.test/auth/v1',
        httpClient: server.client,
      );
      final offline = GoTrueAuthRepository(
        client: client,
        store: store,
        google: google,
      );
      addTearDown(() async {
        client.stopAutoRefresh();
        await offline.dispose();
      });
      await offline.restore();

      expect(await offline.accessToken(), isNotNull);
      expect(offline.status, const SignedIn(userId));
    });

    test('a sign-in right after signing out stays signed in', () async {
      // Seen on a Pixel: Android took 3 s to forget the Google account, and
      // the finishing sign-out undid the new sign-in.
      server.respond = (request) async => request.url.path.endsWith('/logout')
          ? http.Response('', 204)
          : FakeServer.json(sessionJson());
      store.values[GoTrueAuthRepository.sessionKey] = jsonEncode(sessionJson());
      await repository.restore();
      google.slowSignOut = Completer<void>();

      final signingOut = repository.signOut();
      expect(repository.status, const SignedOut());
      await settle();

      expect(
        await repository.signInWithGoogle(),
        isA<Success<void, AuthFailure>>(),
      );
      await settle();
      google.slowSignOut!.complete();
      await signingOut;
      await settle();

      expect(repository.status, const SignedIn(userId));
      expect(store.values, contains(GoTrueAuthRepository.sessionKey));
    });

    test('signs out locally even when the server is unreachable', () async {
      store.values[GoTrueAuthRepository.sessionKey] = jsonEncode(sessionJson());
      await repository.restore();

      await repository.signOut();

      expect(repository.status, const SignedOut());
      expect(store.values, isEmpty);
      expect(google.signOuts, 1);
      expect(await repository.accessToken(), isNull);
    });
  });
}
