import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/auth/presentation/sign_out.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/presentation/household_forms.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Home screen (FR-5). In M0 it only shows the empty state; the plant list
/// arrives in M4.
class PlantsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final household = ref.watch(currentHouseholdProvider);
    final hasHousehold = household.value != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plantsTitle),
        actions: [
          if (kDebugMode) ...[
            IconButton(
              tooltip: l10n.nfcSpikeOpenAction,
              onPressed: () => context.push(AppRoutes.nfcSpike),
              icon: const Icon(Icons.nfc),
            ),
            IconButton(
              tooltip: l10n.syncTestOpenAction,
              onPressed: () => context.push(AppRoutes.syncTest),
              icon: const Icon(Icons.sync),
            ),
          ],
          if (hasHousehold)
            IconButton(
              tooltip: l10n.householdTitle,
              onPressed: () => context.push(AppRoutes.household),
              icon: const Icon(Icons.group_outlined),
            ),
          IconButton(
            tooltip: l10n.signOutAction,
            onPressed: () => confirmSignOut(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: switch (household) {
        // Read from the phone: no spinner worth showing.
        AsyncValue(value: null, isLoading: true) => const SizedBox.shrink(),
        AsyncValue(value: null) => const HouseholdSetupView(),
        _ => MessageView(
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
      },
    );
  }
}
