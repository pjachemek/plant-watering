import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/features/app_update/presentation/app_update_controller.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Shown instead of everything else when this version is below the minimum
/// (FR-10). There is no way past it except updating.
class UpdateRequiredScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: MessageView(
          icon: Icons.system_update,
          iconLabel: l10n.updateRequiredTitle,
          title: l10n.updateRequiredTitle,
          body: l10n.updateRequiredBody,
          action: FilledButton.icon(
            onPressed: () => _openStore(context, ref),
            icon: const Icon(Icons.shop_outlined),
            label: Text(l10n.openStoreAction),
          ),
        ),
      ),
    );
  }
}

/// Opens the store listing, or says it couldn't.
Future<void> _openStore(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  final message = AppLocalizations.of(context).storeOpenFailed;
  final opened = await ref.read(openStoreProvider)();
  if (!opened) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// A dismissible prompt under every screen when a newer version is
/// recommended (FR-10).
class UpdatePrompt extends ConsumerWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(
      appUpdateControllerProvider.select((s) => s.showPrompt),
    );
    if (!show) return child;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(child: child),
        Material(
          color: theme.colorScheme.secondaryContainer,
          child: SafeArea(
            top: false,
            child: Semantics(
              container: true,
              liveRegion: true,
              // Message, then actions underneath, like a Material banner:
              // nothing has to share a line, so it wraps at 200% text.
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.system_update,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.updateAvailableMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => ref
                              .read(appUpdateControllerProvider.notifier)
                              .dismissPrompt(),
                          child: Text(l10n.dismissAction),
                        ),
                        TextButton(
                          onPressed: () => _openStore(context, ref),
                          child: Text(l10n.updateAction),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
