// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sign in with an external provider (FR-7, ADR-0022). Success needs no
/// state here: the router leaves the sign-in screen when the auth status
/// changes.

@ProviderFor(SignInController)
final signInControllerProvider = SignInControllerProvider._();

/// Sign in with an external provider (FR-7, ADR-0022). Success needs no
/// state here: the router leaves the sign-in screen when the auth status
/// changes.
final class SignInControllerProvider
    extends $NotifierProvider<SignInController, SignInState> {
  /// Sign in with an external provider (FR-7, ADR-0022). Success needs no
  /// state here: the router leaves the sign-in screen when the auth status
  /// changes.
  SignInControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInControllerHash();

  @$internal
  @override
  SignInController create() => SignInController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInState>(value),
    );
  }
}

String _$signInControllerHash() => r'0f89d333dd6d7b866b99c6eb3e64e61c6fd9a0f7';

/// Sign in with an external provider (FR-7, ADR-0022). Success needs no
/// state here: the router leaves the sign-in screen when the auth status
/// changes.

abstract class _$SignInController extends $Notifier<SignInState> {
  SignInState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SignInState, SignInState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignInState, SignInState>,
              SignInState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
