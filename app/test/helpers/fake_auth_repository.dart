import 'dart:async';

import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

/// An [AuthRepository] for widget tests. Each sign-in step answers with the
/// result set on it and, on success, signs in.
class FakeAuthRepository implements AuthRepository {
  new({bool signedIn = true})
    : _status = signedIn ? const SignedIn(userId) : const SignedOut();

  static const String userId = '0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e71';

  AuthStatus _status;
  final StreamController<AuthStatus> _changes =
      StreamController<AuthStatus>.broadcast();

  Result<void, AuthFailure> googleResult = const Success(null);
  Result<void, AuthFailure> emailResult = const Success(null);
  Result<void, AuthFailure> linkResult = const Success(null);

  /// Completes the next sign-in step only when set and completed by the test.
  Completer<void>? hold;

  final List<String> emailsSent = [];
  final List<String> codesUsed = [];
  int signOuts = 0;

  @override
  AuthStatus get status => _status;

  @override
  Stream<AuthStatus> get statusChanges => _changes.stream;

  void setStatus(AuthStatus status) {
    _status = status;
    _changes.add(status);
  }

  @override
  Future<void> restore() async {}

  Future<Result<void, AuthFailure>> _step(
    Result<void, AuthFailure> result, {
    bool signsIn = true,
  }) async {
    await hold?.future;
    if (result.isSuccess && signsIn) setStatus(const SignedIn(userId));
    return result;
  }

  @override
  Future<Result<void, AuthFailure>> signInWithGoogle() => _step(googleResult);

  @override
  Future<Result<void, AuthFailure>> sendEmailLink(String email) {
    emailsSent.add(email);
    return _step(emailResult, signsIn: false);
  }

  @override
  Future<Result<void, AuthFailure>> completeEmailLink(String code) {
    codesUsed.add(code);
    return _step(linkResult);
  }

  @override
  Future<String?> accessToken() async =>
      _status is SignedIn ? 'test-access-token' : null;

  @override
  Future<void> signOut() async {
    signOuts++;
    setStatus(const SignedOut());
  }
}
