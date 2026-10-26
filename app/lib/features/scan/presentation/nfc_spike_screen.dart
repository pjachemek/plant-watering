import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/presentation/nfc_spike_controller.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Developer screen for M1: write a test link to a sticker and read stickers
/// back. Only reachable in debug builds. The production write flow (FR-3)
/// arrives in M4 and will reuse the same [NfcService].
class NfcSpikeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(nfcSpikeControllerProvider);
    final controller = ref.read(nfcSpikeControllerProvider.notifier);

    ref.listen(nfcSpikeControllerProvider, (previous, next) {
      if (next is NfcSpikeWritten || next is NfcSpikeRead) {
        unawaited(HapticFeedback.mediumImpact());
      }
    });

    final busy = state is NfcSpikeWaiting;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.nfcSpikeTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            Text(l10n.nfcSpikeIntro),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: busy ? null : controller.write,
              icon: const Icon(Icons.edit),
              label: Text(l10n.nfcWriteAction),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: busy ? null : controller.read,
              icon: const Icon(Icons.nfc),
              label: Text(l10n.nfcReadAction),
            ),
            const SizedBox(height: AppSpacing.xl),
            _StatusCard(state: state, controller: controller),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const new({required this.state, required this.controller});

  final NfcSpikeState state;
  final NfcSpikeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final (
      IconData icon,
      String title,
      String? body,
      List<Widget> actions,
    ) = switch (state) {
      NfcSpikeIdle() => (Icons.nfc, '', null, const <Widget>[]),
      NfcSpikeWaiting() => (
        Icons.contactless_outlined,
        l10n.nfcHoldNearTitle,
        l10n.nfcHoldNearBody,
        [
          TextButton(
            onPressed: controller.cancel,
            child: Text(l10n.cancelAction),
          ),
        ],
      ),
      NfcSpikeWritten() => (
        Icons.check_circle_outline,
        l10n.nfcWriteSuccess,
        null,
        const <Widget>[],
      ),
      NfcSpikeRead(:final content) => _readResult(context, content),
      NfcSpikeConfirmOverwrite(:final existing) => (
        Icons.warning_amber_outlined,
        existing is PlantLinkTag
            ? l10n.nfcOverwritePlantTitle
            : l10n.nfcOverwriteForeignTitle,
        l10n.nfcOverwriteBody,
        [
          TextButton(
            onPressed: controller.cancel,
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: controller.confirmOverwrite,
            child: Text(l10n.nfcOverwriteAction),
          ),
        ],
      ),
      NfcSpikeFailed(:final failure) => (
        Icons.error_outline,
        _failureMessage(l10n, failure),
        null,
        [
          FilledButton(
            onPressed: controller.retry,
            child: Text(l10n.retryAction),
          ),
        ],
      ),
    };

    if (state is NfcSpikeIdle) return const SizedBox.shrink();

    // Announced to screen readers when it changes; the icon is decorative
    // because the title already says what happened.
    return Semantics(
      liveRegion: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(
                child: Icon(
                  icon,
                  size: AppSizes.iconLg,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (body != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (IconData, String, String?, List<Widget>) _readResult(
    BuildContext context,
    TagContent content,
  ) {
    final l10n = AppLocalizations.of(context);
    return switch (content) {
      PlantLinkTag(:final token) => (
        Icons.local_florist_outlined,
        l10n.nfcReadPlantLink,
        null,
        [
          FilledButton(
            onPressed: () => context.go(AppRoutes.tagPath(token.value)),
            child: Text(l10n.nfcOpenTagAction),
          ),
        ],
      ),
      EmptyTag() => (Icons.crop_square, l10n.nfcReadEmpty, null, <Widget>[]),
      ForeignDataTag() => (
        Icons.help_outline,
        l10n.nfcReadForeign,
        null,
        <Widget>[],
      ),
    };
  }

  static String _failureMessage(AppLocalizations l10n, NfcFailure failure) =>
      switch (failure) {
        NfcUnavailable(availability: NfcAvailability.disabled) =>
          l10n.nfcErrorDisabled,
        NfcUnavailable() => l10n.nfcErrorUnsupported,
        TagNotNdef() => l10n.nfcErrorNotNdef,
        TagReadOnly() => l10n.nfcErrorReadOnly,
        TagTooSmall() => l10n.nfcErrorTooSmall,
        TagLost() => l10n.nfcErrorTagLost,
        WriteNotVerified() => l10n.nfcErrorNotVerified,
        OverwriteNeedsConfirmation() ||
        NfcCancelled() ||
        NfcUnknownFailure() => l10n.nfcErrorUnknown,
      };
}
