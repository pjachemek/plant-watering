import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/features/auth/presentation/auth_failure_text.dart';
import 'package:plantnfc/features/auth/presentation/sign_in_controller.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Sign in with Google or an email link (FR-7). Leaving this screen is the
/// router's job: it moves on as soon as someone is signed in.
class SignInScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _sendLink() =>
      ref.read(signInControllerProvider.notifier).sendEmailLink(_email.text);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(signInControllerProvider);
    final controller = ref.read(signInControllerProvider.notifier);
    final sentTo = state.linkSentTo;

    if (sentTo != null) {
      return Scaffold(
        body: MessageView(
          icon: Icons.mark_email_read_outlined,
          iconLabel: l10n.signInLinkSentTitle,
          title: l10n.signInLinkSentTitle,
          body: l10n.signInLinkSentBody(sentTo),
          action: OutlinedButton(
            onPressed: controller.reset,
            child: Text(l10n.signInDifferentEmailAction),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final busy = state.busy != null;
    final googleEnabled = ref
        .watch(appConfigProvider)
        .googleWebClientId
        .isNotEmpty;
    final failure = state.failure;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: AutofillGroup(
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
                    if (googleEnabled) ...[
                      FilledButton.icon(
                        onPressed: busy ? null : controller.signInWithGoogle,
                        icon: state.busy == SignInStep.google
                            ? const _ButtonProgress()
                            : const Icon(Icons.account_circle_outlined),
                        label: Text(l10n.signInGoogleAction),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.signInOr,
                        style: theme.textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    TextField(
                      controller: _email,
                      enabled: !busy,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      autocorrect: false,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendLink(),
                      decoration: InputDecoration(
                        labelText: l10n.signInEmailLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.tonalIcon(
                      onPressed: busy ? null : _sendLink,
                      icon: state.busy == SignInStep.email
                          ? const _ButtonProgress()
                          : const Icon(Icons.mail_outline),
                      label: Text(l10n.signInEmailAction),
                    ),
                  ],
                ),
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
