import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/ids/uuid_v7.dart';

/// What a change is about; the names are the contract's `SyncEntity`.
enum ChangeEntity {
  household('household'),
  plant('plant'),
  tag('tag'),
  wateringEvent('watering_event');

  new(this.apiName);

  final String apiName;
}

/// The contract's `SyncOp`: `upsert` creates or patches, `delete` soft
/// deletes (for a watering, it is the undo).
enum ChangeOp {
  upsert('upsert'),
  delete('delete');

  new(this.apiName);

  final String apiName;
}

/// One change made on this phone, in the contract's shape (`PushChange`):
/// [patch] uses the API's field names, and for a household, plant or tag
/// upsert only the [fields] it lists change (a listed field missing from the
/// patch is cleared). Watering events are created whole.
@immutable
class LocalChange {
  const new({
    required this.householdId,
    required this.entity,
    required this.op,
    required this.rowId,
    this.patch = const {},
    this.fields,
  });

  final String householdId;
  final ChangeEntity entity;
  final ChangeOp op;
  final String rowId;
  final Map<String, Object?> patch;

  /// The fields this upsert sets; `null` means the keys of [patch].
  final List<String>? fields;

  Set<String> get fieldSet => (fields ?? patch.keys).toSet();
}

/// Applies changes to the local tables and queues them for the API in the
/// same transaction, so the UI updates at once, offline included, and
/// nothing is lost if the app is killed (AGENTS.md section 5, NFR Offline).
class LocalChanges {
  new(this._db, {DateTime Function()? clock, String Function()? newId})
    : _clock = clock ?? DateTime.now,
      _newId = newId ?? uuidV7;

  final AppDatabase _db;
  final DateTime Function() _clock;
  final String Function() _newId;

  /// Applies [change] as [userId] and queues it; returns its change id.
  Future<String> record(LocalChange change, {required String userId}) =>
      _db.transaction(() async {
        final now = _clock().toUtc();
        await _apply(change, now, userId);
        final changeId = _newId();
        await _db
            .into(_db.outbox)
            .insert(
              OutboxCompanion.insert(
                changeId: changeId,
                householdId: change.householdId,
                entity: change.entity.apiName,
                op: change.op.apiName,
                rowId: change.rowId,
                fields: Value(
                  change.op == ChangeOp.upsert &&
                          change.entity != ChangeEntity.wateringEvent
                      ? jsonEncode(change.fieldSet.toList())
                      : null,
                ),
                patch: Value(
                  change.op == ChangeOp.upsert
                      ? jsonEncode(change.patch)
                      : null,
                ),
                createdAt: now,
              ),
            );
        return changeId;
      });

  /// Re-applies this phone's queued changes to [rowIds] of [householdId],
  /// in the order they were made, after a pull wrote the server's version:
  /// what the person changed stays on screen until the API has it.
  /// Call inside the pull's transaction.
  Future<void> reapplyPending({
    required String householdId,
    required Set<String> rowIds,
    required String userId,
  }) async {
    if (rowIds.isEmpty) return;
    final pending =
        await (_db.select(_db.outbox)
              ..where(
                (o) => o.householdId.equals(householdId) & o.rowId.isIn(rowIds),
              )
              ..orderBy([(o) => OrderingTerm(expression: o.seq)]))
            .get();
    final now = _clock().toUtc();
    for (final row in pending) {
      await _apply(changeOf(row), now, userId);
    }
  }

  Future<void> _apply(LocalChange change, DateTime now, String userId) =>
      switch (change.entity) {
        ChangeEntity.household => _household(change, now),
        ChangeEntity.plant => _plant(change, now),
        ChangeEntity.tag => _tag(change, now, userId),
        ChangeEntity.wateringEvent => _watering(change, now, userId),
      };

  Future<void> _household(LocalChange c, DateTime now) async {
    if (c.op == ChangeOp.delete) {
      throw ArgumentError('Households are not deleted through sync');
    }
    final f = _Fields(c);
    await (_db.update(
      _db.households,
    )..where((h) => h.id.equals(c.rowId))).write(
      HouseholdsCompanion(
        name: f.required('name'),
        publicCardsEnabled: f.required('public_cards_enabled'),
        hemisphere: f.required('hemisphere'),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> _plant(LocalChange c, DateTime now) async {
    final where = _db.plants.id.equals(c.rowId);
    if (c.op == ChangeOp.delete) {
      await (_db.update(_db.plants)..where((_) => where)).write(
        PlantsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      // Its sticker becomes free to link again, as on the server.
      await (_db.update(
        _db.tags,
      )..where((t) => t.plantId.equals(c.rowId))).write(
        TagsCompanion(plantId: const Value(null), updatedAt: Value(now)),
      );
      return;
    }
    final f = _Fields(c);
    final values = PlantsCompanion(
      nickname: f.required('nickname'),
      presetId: f.value('preset_id'),
      presetVersion: f.value('preset_version'),
      room: f.value('room'),
      photoPath: f.value('photo_path'),
      intervalSummerDays: f.value('interval_summer_days'),
      intervalWinterDays: f.value('interval_winter_days'),
      amount: f.value('amount'),
      method: f.value('method'),
      notes: f.value('notes'),
      updatedAt: Value(now),
    );
    final exists = await (_db.select(
      _db.plants,
    )..where((_) => where)).getSingleOrNull();
    if (exists == null) {
      await _db
          .into(_db.plants)
          .insert(
            values.copyWith(
              id: Value(c.rowId),
              householdId: Value(c.householdId),
              createdAt: Value(now),
            ),
          );
    } else {
      await (_db.update(_db.plants)..where((_) => where)).write(values);
    }
  }

  Future<void> _tag(LocalChange c, DateTime now, String userId) async {
    final where = _db.tags.id.equals(c.rowId);
    if (c.op == ChangeOp.delete) {
      await (_db.update(_db.tags)..where((_) => where)).write(
        TagsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      return;
    }
    final f = _Fields(c);
    final plantId = f.value<String>('plant_id');
    if (plantId case Value(present: true, value: final String plant)) {
      // One active tag per plant: the newest link wins (ADR-0019).
      await (_db.update(
            _db.tags,
          )..where((t) => t.plantId.equals(plant) & t.id.equals(c.rowId).not()))
          .write(
            TagsCompanion(plantId: const Value(null), updatedAt: Value(now)),
          );
    }
    final writtenAt = f.dateTime('written_at');
    final values = TagsCompanion(
      token: f.required('token'),
      plantId: plantId,
      writtenAt: writtenAt,
      writtenBy: writtenAt.present
          ? Value(writtenAt.value == null ? null : userId)
          : const Value.absent(),
      updatedAt: Value(now),
    );
    final exists = await (_db.select(
      _db.tags,
    )..where((_) => where)).getSingleOrNull();
    if (exists == null) {
      await _db
          .into(_db.tags)
          .insert(
            values.copyWith(
              id: Value(c.rowId),
              householdId: Value(c.householdId),
            ),
          );
    } else {
      await (_db.update(_db.tags)..where((_) => where)).write(values);
    }
  }

  Future<void> _watering(LocalChange c, DateTime now, String userId) async {
    if (c.op == ChangeOp.delete) {
      await (_db.update(_db.wateringEvents)
            ..where((w) => w.id.equals(c.rowId) & w.deletedAt.isNull()))
          .write(WateringEventsCompanion(deletedAt: Value(now)));
      return;
    }
    await _db
        .into(_db.wateringEvents)
        .insert(
          WateringEventsCompanion.insert(
            id: c.rowId,
            householdId: c.householdId,
            plantId: c.patch['plant_id']! as String,
            userId: Value(userId),
            wateredAt: DateTime.parse(c.patch['watered_at']! as String).toUtc(),
            source: c.patch['source']! as String,
            createdAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }
}

/// The [LocalChange] an outbox row was made from.
LocalChange changeOf(OutboxRow row) {
  final fields = row.fields;
  final patch = row.patch;
  return LocalChange(
    householdId: row.householdId,
    entity: ChangeEntity.values.firstWhere((e) => e.apiName == row.entity),
    op: ChangeOp.values.firstWhere((o) => o.apiName == row.op),
    rowId: row.rowId,
    patch: patch == null
        ? const {}
        : (jsonDecode(patch) as Map<String, Object?>),
    fields: fields == null
        ? null
        : (jsonDecode(fields) as List<Object?>).cast<String>(),
  );
}

/// Reads one change's patch the way the API applies it: a listed field takes
/// the patch's value or null; an unlisted one stays as it is.
class _Fields {
  new(this._change) : _listed = _change.fieldSet;

  final LocalChange _change;
  final Set<String> _listed;

  Value<T?> value<T extends Object>(String name) => _listed.contains(name)
      ? Value(_change.patch[name] as T?)
      : const Value.absent();

  /// For a column that can't be null: absent unless listed.
  Value<T> required<T extends Object>(String name) => _listed.contains(name)
      ? Value(_change.patch[name]! as T)
      : const Value.absent();

  Value<DateTime?> dateTime(String name) {
    if (!_listed.contains(name)) return const Value.absent();
    final raw = _change.patch[name] as String?;
    return Value(raw == null ? null : DateTime.parse(raw).toUtc());
  }
}
