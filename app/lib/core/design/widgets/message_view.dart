import 'package:flutter/material.dart';
import 'package:plantnfc/core/design/tokens.dart';

/// Centered icon, title, body and optional action. Used for empty, error and
/// placeholder states. Scrolls so it stays usable at 200% text size.
class MessageView extends StatelessWidget {
  const new({
    required this.icon,
    required this.iconLabel,
    required this.title,
    this.body,
    this.action,
    super.key,
  });

  final IconData icon;

  /// Screen reader label for [icon].
  final String iconLabel;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = this.body;
    final action = this.action;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconXl,
                  color: theme.colorScheme.primary,
                  semanticLabel: iconLabel,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (body != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    body,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
