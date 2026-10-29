import 'dart:async';
import 'dart:convert';

import 'package:gotrue/gotrue.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/data/google_id_token_source.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/domain/email_address.dart';

/// [AuthRepository] on Supabase Auth through `gotrue`, the auth client alone
/// rather than the full Supabase SDK: the app reaches data only through the
/// API (ADR-0012, ADR-0021).
class GoTrueAuthRepository implements AuthRepository {
  new({
    required this._client,
    required this._store,
    required this._google,
    required this._emailRedirect,
  });

  /// Where the saved session lives in [GotrueAsyncStorage].
  static const String sessionKey = 'plantnfc.auth.session';

  /// Supabase Auth's code for an address it won't send to (not in the
  /// client's [ErrorCode] list).
  static const String _emailAddressInvalid = 'email_address_invalid';

  final GoTrueClient _client;
  final GotrueAsyncStorage _store;
  final GoogleIdTokenSource _google;
  final Uri _emailRedirect;
  final StreamController<AuthStatus> _changes =
      StreamController<AuthStatus>.broadcast();
  StreamSubscription<AuthState>? _subscription;
  AuthStatus _status = const SignedOut();

  @override
  AuthStatus get status => _status;

  @override
  Stream<AuthStatus> get statusChanges => _changes.stream;

  @override
  Future<void> restore() async {
    _subscription ??= _client.onAuthStateChange.listen(
      _onAuthChange,
      // A failed background refresh is reported here. Offline it is retried;
      // a revoked session also emits signedOut, handled above.
      onError: (Object _) {},
    );
    final saved = await _store.getItem(key: sessionKey);
    if (saved != null) {
      try {
        // No network: the saved access token is used until it expires, then
        // refreshed when there is a connection.
        await _client.setInitialSession(saved);
      } on Object {
        await _store.removeItem(key: sessionKey);
      }
    }
    _setStatus(_client.currentSession);
  }

  void _onAuthChange(AuthState state) {
    // Events can arrive after a newer change (gotrue reports signedOut only
    // after clearing its storage), so act on the client's current session,
    // never on the session the event carries.
    final session = _client.currentSession;
    const saves = {
      AuthChangeEvent.signedIn,
      AuthChangeEvent.tokenRefreshed,
      AuthChangeEvent.userUpdated,
    };
    if (session != null && saves.contains(state.event)) {
      unawaited(
        _store.setItem(key: sessionKey, value: jsonEncode(session.toJson())),
      );
    } else if (session == null && state.event == AuthChangeEvent.signedOut) {
      unawaited(_store.removeItem(key: sessionKey));
    }
    _setStatus(session);
  }

  void _setStatus(Session? session) {
    final next = session == null
        ? const SignedOut()
        : SignedIn(session.user.id);
    if (next == _status) return;
    _status = next;
    _changes.add(next);
  }

  @override
  Future<Result<void, AuthFailure>> signInWithGoogle() async {
    final token = await _google.signIn();
    switch (token) {
      case Failure(:final failure):
        return Failure(failure);
      case Success(:final value):
        return await _attempt(
          () => _client.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: value.idToken,
            nonce: value.rawNonce,
          ),
          onRejected: AuthFailure.unknown,
        );
    }
  }

  @override
  Future<Result<void, AuthFailure>> sendEmailLink(String email) async {
    final address = normalizeEmail(email);
    if (address == null) return const Failure(AuthFailure.invalidEmail);
    return await _attempt(
      () => _client.signInWithOtp(
        email: address,
        emailRedirectTo: _emailRedirect.toString(),
      ),
      onRejected: AuthFailure.unknown,
    );
  }

  @override
  Future<Result<void, AuthFailure>> completeEmailLink(String code) =>
      // Any refusal means the link can't be used: used, expired, or opened
      // on another phone (whose code verifier we don't have).
      _attempt(
        () => _client.exchangeCodeForSession(code),
        onRejected: AuthFailure.linkInvalid,
      );

  /// Runs one Supabase Auth call and maps its errors.
  Future<Result<void, AuthFailure>> _attempt(
    Future<Object?> Function() call, {
    required AuthFailure onRejected,
  }) async {
    try {
      await call();
      return const Success(null);
    } on AuthRetryableFetchException {
      return const Failure(AuthFailure.network);
    } on AuthException catch (error) {
      return Failure(_failureFor(error, onRejected));
    } on Exception {
      // http's ClientException and socket errors: no connection.
      return const Failure(AuthFailure.network);
    }
  }

  AuthFailure _failureFor(AuthException error, AuthFailure fallback) {
    if (error.statusCode == '429' ||
        error.code == ErrorCode.overEmailSendRateLimit.code) {
      return AuthFailure.rateLimited;
    }
    if (error.code == _emailAddressInvalid) {
      return AuthFailure.invalidEmail;
    }
    // The project has this way of signing in turned off: retrying won't help.
    if (error.code == ErrorCode.emailProviderDisabled.code ||
        error.code == ErrorCode.providerDisabled.code) {
      return AuthFailure.notConfigured;
    }
    return fallback;
  }

  @override
  Future<String?> accessToken() async {
    try {
      return (await _client.getSession())?.accessToken;
    } on AuthRetryableFetchException {
      // Offline with an expired token: the API answers 401 and the caller
      // retries once online. Never sign out for lack of network.
      return _client.currentSession?.accessToken;
    } on AuthException {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    // Everything that must happen at once happens before the first await,
    // so a sign-in started right afterwards can't be undone by a slow step
    // (seen on a device: forgetting the Google account took 3 s).
    final steps = [
      _store.removeItem(key: sessionKey),
      // Clears the session locally, then revokes it on the server. Offline,
      // the old refresh token expires on its own.
      _client.signOut().catchError((Object _) {}),
      _google.signOut().catchError((Object _) {}),
    ];
    _setStatus(_client.currentSession);
    await Future.wait(steps);
  }

  /// Stops listening; for tests and provider disposal.
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _changes.close();
  }
}
