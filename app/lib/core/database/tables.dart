import 'package:drift/drift.dart';

// Local copies of the household's data (AGENTS.md sections 5 and 8). The UI
// reads only these tables; the sync engine keeps them in step with the API.
// Columns follow the API contract (functions/openapi.yaml), not the server's
// own bookkeeping (change_xid stays on the server). Times are UTC.

@DataClassName('HouseholdRow')
class Households extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get publicCardsEnabled => boolean()();
  TextColumn get hemisphere => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MemberRow')
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  DateTimeColumn get joinedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PlantRow')
@TableIndex(name: 'plants_household', columns: {#householdId})
class Plants extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get nickname => text()();
  TextColumn get presetId => text().nullable()();
  IntColumn get presetVersion => integer().nullable()();
  TextColumn get room => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get intervalSummerDays => integer().nullable()();
  IntColumn get intervalWinterDays => integer().nullable()();
  TextColumn get amount => text().nullable()();
  TextColumn get method => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TagRow')
// A token is unique among active tags only: deleting a tag frees its
// sticker at once, as on the server (ADR-0027).
@TableIndex.sql(
  'CREATE UNIQUE INDEX tags_active_token ON tags (token) '
  'WHERE deleted_at IS NULL',
)
@TableIndex(name: 'tags_plant', columns: {#plantId})
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get token => text()();
  TextColumn get plantId => text().nullable()();
  DateTimeColumn get writtenAt => dateTime().nullable()();
  TextColumn get writtenBy => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WateringEventRow')
@TableIndex(name: 'watering_plant_time', columns: {#plantId, #wateredAt})
class WateringEvents extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get plantId => text()();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get wateredAt => dateTime()();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// Set when the watering was undone.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Changes made on this phone and not yet accepted by the API, in the order
/// they were made (AGENTS.md section 5, step 2). Each row is one
/// `PushChange` of the contract.
@DataClassName('OutboxRow')
@TableIndex(name: 'outbox_household', columns: {#householdId, #seq})
class Outbox extends Table {
  IntColumn get seq => integer().autoIncrement()();

  /// The change's own UUID v7; the API's ledger keys retries on it.
  TextColumn get changeId => text().unique()();
  TextColumn get householdId => text()();

  /// `household`, `plant`, `tag` or `watering_event`.
  TextColumn get entity => text()();

  /// `upsert` or `delete`.
  TextColumn get op => text()();
  TextColumn get rowId => text()();

  /// JSON array of the field names this upsert sets, or null.
  TextColumn get fields => text().nullable()();

  /// JSON object with the patch, or null for a delete.
  TextColumn get patch => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  /// The Idempotency-Key of the push that last carried this change, kept so
  /// a retry of the same batch reuses it (ADR-0019).
  TextColumn get batchKey => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
}

/// Where each household's pull got to (ADR-0014).
@DataClassName('SyncStateRow')
class SyncStates extends Table {
  TextColumn get householdId => text()();

  /// The opaque cursor from the last pull, or null before the first.
  TextColumn get cursor => text().nullable()();
  DateTimeColumn get pulledAt => dateTime().nullable()();

  /// Set when the API rejected a change: the next pull fetches everything,
  /// so rows the server never accepted disappear from this phone.
  BoolColumn get fullPullNeeded =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {householdId};
}
