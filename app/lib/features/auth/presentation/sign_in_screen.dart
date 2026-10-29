import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/presentation/auth_failure_text.dart';
import 'package:plantnfc/features/auth/presentation/sign_in_controller.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Sign in with an external provider (FR-7, ADR-0022): Google on Android,
/// Apple too once iOS resumes. Leaving this screen is the router's job: it
/// moves on as soon as someone is signed in.
class SignInScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(signInControllerProvider);
    final controller = ref.read(signInControllerProvider.notifier);
    final googleEnabled = ref
        .watch(appConfigProvider)
        .googleWebClientId
        .isNotEmpty;
    // A build without any provider can't sign anyone in; say so up front.
    final failure =
        state.failure ?? (googleEnabled ? null : AuthFailure.notConfigured);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.local_florist_outlined,
                    size: AppSizes.iconXl,
                    color: theme.colorScheme.primary,
                    semanticLabel: l10n.signInIllustrationLabel,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.signInTitle,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.signInBody,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (failure != null) ...[
                    _FailureMessage(text: authFailureText(l10n, failure)),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (googleEnabled)
                    FilledButton.icon(
                      onPressed: state.busy
                          ? null
                          : controller.signInWithGoogle,
                      icon: state.busy
                          ? const _ButtonProgress()
                          : const Icon(Icons.account_circle_outlined),
                      label: Text(l10n.signInGoogleAction),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An error with an icon, so it doesn't rely on colour alone (NFR
/// Accessibility), announced by screen readers when it appears.
class _FailureMessage extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, color: colors.onErrorContainer),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonProgress extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: AppSizes.iconSm,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
