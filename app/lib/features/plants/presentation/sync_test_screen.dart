import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/database/local_changes.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/ids/uuid_v7.dart';
import 'package:plantnfc/core/sync/live_updates.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/domain/household.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Developer screen for the M2 exit test (debug builds only): add test
/// plants, water them and undo, and watch the changes reach other phones.
/// It reads and writes the local database directly; the real plant screens
/// (M4) go through feature repositories.
class SyncTestScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final household = ref.watch(currentHouseholdProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncTestTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              l10n.syncTestStatus(
                ref.watch(syncControllerProvider).name,
                ref.watch(liveUpdatesProvider).name,
                ref.watch(outboxSizeProvider).value ?? 0,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (household == null)
              Text(l10n.syncTestNoHousehold)
            else ...[
              FilledButton.icon(
                onPressed: () => _addPlant(ref, household),
                icon: const Icon(Icons.add),
                label: Text(l10n.syncTestAddPlant),
              ),
              const SizedBox(height: AppSpacing.lg),
              _Plants(household: household),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addPlant(WidgetRef ref, HouseholdSummary household) async {
    final userId = _userId(ref);
    if (userId == null) return;
    final id = uuidV7();
    await ref
        .read(localChangesProvider)
        .record(
          LocalChange(
            householdId: household.id,
            entity: ChangeEntity.plant,
            op: ChangeOp.upsert,
            rowId: id,
            patch: {
              'nickname': 'Test plant ${id.substring(9, 13)}',
              'interval_summer_days': 7,
              'interval_winter_days': 14,
              'method': 'top',
              'amount': 'medium',
            },
          ),
          userId: userId,
        );
  }
}

String? _userId(WidgetRef ref) =>
    switch (ref.read(authRepositoryProvider).status) {
      SignedIn(:final userId) => userId,
      SignedOut() => null,
    };

class _Plants extends ConsumerWidget {
  const new({required this.household});

  final HouseholdSummary household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return StreamBuilder<List<PlantRow>>(
      stream:
          (db.select(db.plants)
                ..where(
                  (p) =>
                      p.householdId.equals(household.id) & p.deletedAt.isNull(),
                )
                ..orderBy([(p) => OrderingTerm(expression: p.createdAt)]))
              .watch(),
      builder: (context, plants) => Column(
        children: [
          for (final plant in plants.data ?? const <PlantRow>[])
            _PlantTile(plant: plant, household: household),
        ],
      ),
    );
  }
}

class _PlantTile extends ConsumerWidget {
  const new({required this.plant, required this.household});

  final PlantRow plant;
  final HouseholdSummary household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(appDatabaseProvider);
    final lastWatering =
        (db.select(db.wateringEvents)
              ..where((w) => w.plantId.equals(plant.id) & w.deletedAt.isNull())
              ..orderBy([(w) => OrderingTerm.desc(w.wateredAt)])
              ..limit(1))
            .watchSingleOrNull();
    return StreamBuilder<WateringEventRow?>(
      stream: lastWatering,
      builder: (context, snapshot) {
        final last = snapshot.data;
        final who = household.members
            .where((m) => m.userId == last?.userId)
            .map((m) => m.displayName)
            .firstOrNull;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.nickname,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  last == null
                      ? l10n.syncTestNeverWatered
                      : l10n.syncTestLastWatered(
                          last.wateredAt.toLocal(),
                          who ?? l10n.syncTestSomeone,
                        ),
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: last == null
                          ? null
                          : () => _record(
                              ref,
                              ChangeOp.delete,
                              last.id,
                              const {},
                            ),
                      child: Text(l10n.syncTestUndo),
                    ),
                    FilledButton(
                      onPressed: () => _record(ref, ChangeOp.upsert, uuidV7(), {
                        'plant_id': plant.id,
                        'watered_at': DateTime.now().toUtc().toIso8601String(),
                        'source': 'list',
                      }),
                      child: Text(l10n.syncTestWater),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _record(
    WidgetRef ref,
    ChangeOp op,
    String id,
    Map<String, Object?> patch,
  ) async {
    final userId = _userId(ref);
    if (userId == null) return;
    await ref
        .read(localChangesProvider)
        .record(
          LocalChange(
            householdId: household.id,
            entity: ChangeEntity.wateringEvent,
            op: op,
            rowId: id,
            patch: patch,
          ),
          userId: userId,
        );
  }
}
