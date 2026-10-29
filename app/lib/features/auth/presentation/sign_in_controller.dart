import 'package:meta/meta.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

enum SignInStep { google, email }

/// What the sign-in screen shows.
@immutable
class SignInState {
  const new({this.busy, this.linkSentTo, this.failure});

  /// The step in progress, if any. Buttons are disabled meanwhile.
  final SignInStep? busy;

  /// Set once the email link is on its way.
  final String? linkSentTo;

  /// The last failure, shown with a way to recover.
  final AuthFailure? failure;

  @override
  bool operator ==(Object other) =>
      other is SignInState &&
      other.busy == busy &&
      other.linkSentTo == linkSentTo &&
      other.failure == failure;

  @override
  int get hashCode => Object.hash(busy, linkSentTo, failure);
}

/// Sign in with Google or an email link (FR-7). Success needs no state here:
/// the router leaves the sign-in screen when the auth status changes.
@riverpod
class SignInController extends _$SignInController {
  @override
  SignInState build() => const SignInState();

  Future<void> signInWithGoogle() async {
    if (state.busy != null) return;
    state = const SignInState(busy: SignInStep.google);
    final result = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (!ref.mounted) return;
    state = switch (result) {
      Success() => const SignInState(),
      // Closing the account picker is not an error.
      Failure(failure: AuthFailure.cancelled) => const SignInState(),
      Failure(:final failure) => SignInState(failure: failure),
    };
  }

  Future<void> sendEmailLink(String email) async {
    if (state.busy != null) return;
    state = const SignInState(busy: SignInStep.email);
    final result = await ref.read(authRepositoryProvider).sendEmailLink(email);
    if (!ref.mounted) return;
    state = switch (result) {
      Success() => SignInState(linkSentTo: email.trim()),
      Failure(:final failure) => SignInState(failure: failure),
    };
  }

  /// Back to the form, for example to use another address.
  void reset() => state = const SignInState();
}
