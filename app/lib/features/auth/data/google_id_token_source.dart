import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

/// A Google ID token and the raw nonce it is bound to.
@immutable
class GoogleIdToken {
  const new({required this.idToken, required this.rawNonce});

  final String idToken;

  /// Sent to Supabase, which checks that its SHA-256 is the token's `nonce`.
  final String rawNonce;
}

/// The platform Google account picker, behind an interface so tests can fake
/// it (AGENTS.md section 5).
abstract interface class GoogleIdTokenSource {
  Future<Result<GoogleIdToken, AuthFailure>> signIn();

  /// Forgets the chosen account, so the picker shows next time.
  Future<void> signOut();
}

/// Android Credential Manager through `google_sign_in` (ADR-0021).
class PluginGoogleIdTokenSource implements GoogleIdTokenSource {
  new({required this.serverClientId, GoogleSignIn? plugin})
    : _plugin = plugin ?? GoogleSignIn.instance;

  /// The Web OAuth client id that Supabase accepts tokens for.
  final String serverClientId;
  final GoogleSignIn _plugin;

  // The plugin can be initialised only once per process, and the nonce is
  // part of that, so one random nonce serves every attempt in this process.
  // It never leaves memory except as its hash (to Google) and itself (to
  // Supabase, over TLS).
  late final String _rawNonce = randomNonce();
  Future<void>? _initialized;

  @override
  Future<Result<GoogleIdToken, AuthFailure>> signIn() async {
    if (serverClientId.isEmpty) return const Failure(AuthFailure.notConfigured);
    try {
      await (_initialized ??= _plugin.initialize(
        serverClientId: serverClientId,
        nonce: sha256Hex(_rawNonce),
      ));
      final account = await _plugin.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return const Failure(AuthFailure.unknown);
      return Success(GoogleIdToken(idToken: idToken, rawNonce: _rawNonce));
    } on GoogleSignInException catch (error) {
      return Failure(failureFor(error.code));
    }
  }

  @override
  Future<void> signOut() async {
    if (_initialized == null) return;
    try {
      await _plugin.signOut();
    } on GoogleSignInException {
      // Nothing to forget.
    }
  }
}

/// Maps the plugin's error codes to what the screen can say and offer.
@visibleForTesting
AuthFailure failureFor(GoogleSignInExceptionCode code) => switch (code) {
  GoogleSignInExceptionCode.canceled => AuthFailure.cancelled,
  // Credential Manager reports a missing network as an interruption.
  GoogleSignInExceptionCode.interrupted => AuthFailure.network,
  GoogleSignInExceptionCode.clientConfigurationError ||
  GoogleSignInExceptionCode.providerConfigurationError =>
    AuthFailure.notConfigured,
  _ => AuthFailure.unknown,
};

/// 32 random bytes, base64url without padding.
@visibleForTesting
String randomNonce([Random? random]) {
  final source = random ?? Random.secure();
  final bytes = List<int>.generate(32, (_) => source.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
}

/// Lower-case hex SHA-256, the form Google expects for the nonce.
@visibleForTesting
String sha256Hex(String value) => sha256.convert(utf8.encode(value)).toString();
