import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/data/google_id_token_source.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

void main() {
  test('maps the plugin errors to what the screen can offer', () {
    expect(
      failureFor(GoogleSignInExceptionCode.canceled),
      AuthFailure.cancelled,
    );
    expect(
      failureFor(GoogleSignInExceptionCode.interrupted),
      AuthFailure.network,
    );
    expect(
      failureFor(GoogleSignInExceptionCode.clientConfigurationError),
      AuthFailure.notConfigured,
    );
    expect(
      failureFor(GoogleSignInExceptionCode.providerConfigurationError),
      AuthFailure.notConfigured,
    );
    expect(
      failureFor(GoogleSignInExceptionCode.uiUnavailable),
      AuthFailure.unknown,
    );
  });

  test('makes 256-bit url-safe nonces that differ', () {
    final nonce = randomNonce();

    expect(nonce, matches(RegExp(r'^[A-Za-z0-9_-]{43}$')));
    expect(randomNonce(), isNot(nonce));
    expect(randomNonce(Random(1)), randomNonce(Random(1)));
  });

  test('hashes the nonce as lower-case hex SHA-256', () {
    expect(
      sha256Hex('abc'),
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
  });

  test('without a client id, reports that sign-in is not set up', () async {
    final source = PluginGoogleIdTokenSource(serverClientId: '');

    expect(
      await source.signIn(),
      const Failure<GoogleIdToken, AuthFailure>(AuthFailure.notConfigured),
    );
    await source.signOut(); // nothing to forget
  });
}
