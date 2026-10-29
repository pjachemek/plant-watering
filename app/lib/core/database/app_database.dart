import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:plantnfc/core/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

/// The app's local database, the source of truth for the UI (AGENTS.md
/// section 5, ADR-0024). SQLite through Drift, on a background isolate.
@DriftDatabase(
  tables: [
    Households,
    Members,
    Plants,
    Tags,
    WateringEvents,
    Outbox,
    SyncStates,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  /// The database file in the app's private storage. App backup is off, so
  /// it never leaves the phone.
  factory open() => AppDatabase(driftDatabase(name: 'plantnfc'));

  /// Bump with every schema change, export the schema
  /// (`dart run drift_dev make-migrations`) and add a migration step: the
  /// generated tests check each step against the real old schema.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) => m.createAll());

  /// Removes one household and everything of it from this phone, its
  /// unsent changes included: after leaving, nothing of it can reach the
  /// server any more.
  Future<void> removeHousehold(String householdId) => transaction(() async {
    await (delete(
      wateringEvents,
    )..where((w) => w.householdId.equals(householdId))).go();
    await (delete(tags)..where((t) => t.householdId.equals(householdId))).go();
    await (delete(
      plants,
    )..where((p) => p.householdId.equals(householdId))).go();
    await (delete(
      members,
    )..where((m) => m.householdId.equals(householdId))).go();
    await (delete(
      outbox,
    )..where((o) => o.householdId.equals(householdId))).go();
    await (delete(
      syncStates,
    )..where((s) => s.householdId.equals(householdId))).go();
    await (delete(households)..where((h) => h.id.equals(householdId))).go();
  });

  /// Removes every household's data, for signing out or leaving.
  Future<void> clearAll() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}

/// The open database for the whole app. Tests override it with an in-memory
/// one.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
}
