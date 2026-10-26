import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Home screen (FR-5). In M0 it only shows the empty state; the plant list
/// arrives in M4.
class PlantsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plantsTitle),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: l10n.nfcSpikeOpenAction,
              onPressed: () => context.push(AppRoutes.nfcSpike),
              icon: const Icon(Icons.nfc),
            ),
        ],
      ),
      body: MessageView(
        icon: Icons.local_florist_outlined,
        iconLabel: l10n.plantsEmptyIllustrationLabel,
        title: l10n.plantsEmptyTitle,
        body: l10n.plantsEmptyBody,
        action: FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
          icon: const Icon(Icons.add),
          label: Text(l10n.addPlantAction),
        ),
      ),
    );
  }
}
