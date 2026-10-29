import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/api/generated/models/household.dart';
import 'package:plantnfc/core/api/generated/models/platform.dart';
import 'package:plantnfc/core/api/generated/models/pull_response.dart';
import 'package:plantnfc/core/api/generated/models/push_change.dart';
import 'package:plantnfc/core/api/generated/models/push_request.dart';
import 'package:plantnfc/core/api/generated/models/push_result_status.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/database/local_changes.dart';
import 'package:plantnfc/core/ids/uuid_v7.dart';
import 'package:plantnfc/core/result/result.dart';

/// One pass of the sync engine (AGENTS.md section 5, ADR-0025): refresh the
/// household list, push each household's outbox, pull what changed. It has
/// no timers; `SyncController` decides when to run it.
class SyncEngine {
  new({
    required this._db,
    required this._api,
    required this._changes,
    String Function()? newKey,
    DateTime Function()? clock,
  }) : _newKey = newKey ?? uuidV7,
       _clock = clock ?? DateTime.now;

  /// The contract's maximum changes per push.
  static const int maxBatch = 500;

  final AppDatabase _db;
  final PlantApiClient _api;
  final LocalChanges _changes;
  final String Function() _newKey;
  final DateTime Function() _clock;

  /// Syncs every household the signed-in [userId] belongs to. Returns the
  /// first failure, or `null` when everything is in step.
  Future<ApiFailure?> syncAll({required String userId}) async {
    final list = await guardApi(
      () => _api.households.listHouseholds(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
      ),
    );
    final List<Household> households;
    switch (list) {
      case Failure(:final failure):
        return failure;
      case Success(:final value):
        households = value.households;
    }
    await _db.transaction(() async {
      final listed = {for (final h in households) h.id};
      // Left, or removed elsewhere: its data goes too, including rows whose
      // household row is already gone (a change queued while leaving).
      for (final id in await _db.localHouseholdIds()) {
        if (!listed.contains(id)) await _db.removeHousehold(id);
      }
      for (final h in households) {
        await _db.into(_db.households).insertOnConflictUpdate(_household(h));
      }
    });
    for (final h in households) {
      final failure = await syncHousehold(h.id, userId: userId);
      if (failure != null) return failure;
    }
    return null;
  }

  /// Pushes [householdId]'s outbox, then pulls its changes.
  Future<ApiFailure?> syncHousehold(
    String householdId, {
    required String userId,
  }) async {
    while (true) {
      final batch = await _nextBatch(householdId);
      if (batch.rows.isEmpty) break;
      final failure = await _push(householdId, batch.key, batch.rows);
      if (failure != null) return failure;
    }
    return await _pull(householdId, userId: userId);
  }

  /// The batch to send: one already sent (same rows, same key, so the API
  /// can answer a retry from its ledger), or the next changes in order with
  /// a new key.
  Future<({String key, List<OutboxRow> rows})> _nextBatch(String householdId) =>
      _db.transaction(() async {
        final queued = _db.select(_db.outbox)
          ..where((o) => o.householdId.equals(householdId))
          ..orderBy([(o) => OrderingTerm(expression: o.seq)]);
        final first = await (queued..limit(1)).getSingleOrNull();
        if (first == null) return (key: '', rows: <OutboxRow>[]);
        final sentKey = first.batchKey;
        if (sentKey != null) {
          final rows =
              await (_db.select(_db.outbox)
                    ..where((o) => o.batchKey.equals(sentKey))
                    ..orderBy([(o) => OrderingTerm(expression: o.seq)]))
                  .get();
          return (key: sentKey, rows: rows);
        }
        final rows =
            await (_db.select(_db.outbox)
                  ..where(
                    (o) =>
                        o.householdId.equals(householdId) & o.batchKey.isNull(),
                  )
                  ..orderBy([(o) => OrderingTerm(expression: o.seq)])
                  ..limit(maxBatch))
                .get();
        final key = _newKey();
        await (_db.update(_db.outbox)
              ..where((o) => o.seq.isIn(rows.map((r) => r.seq))))
            .write(OutboxCompanion(batchKey: Value(key)));
        return (key: key, rows: rows);
      });

  Future<ApiFailure?> _push(
    String householdId,
    String key,
    List<OutboxRow> rows,
  ) async {
    final result = await guardApi(
      () => _api.sync.syncPush(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
        idempotencyKey: key,
        body: PushRequest(
          householdId: householdId,
          changes: rows.map(pushChangeOf).toList(),
        ),
      ),
    );
    switch (result) {
      case Failure(:final failure):
        await (_db.update(
          _db.outbox,
        )..where((o) => o.batchKey.equals(key))).write(
          OutboxCompanion.custom(
            attempts: _db.outbox.attempts + const Constant(1),
          ),
        );
        return failure;
      case Success(:final value):
        await _db.transaction(() async {
          // Applied, duplicate or rejected: the API has decided each one for
          // good (ADR-0019), so none is sent again.
          await (_db.delete(_db.outbox)..where(
                (o) => o.changeId.isIn(value.results.map((r) => r.changeId)),
              ))
              .go();
          if (value.results.any((r) => r.status == PushResultStatus.rejected)) {
            await _markFullPull(householdId);
          }
        });
        return null;
    }
  }

  Future<ApiFailure?> _pull(
    String householdId, {
    required String userId,
  }) async {
    final state = await (_db.select(
      _db.syncStates,
    )..where((s) => s.householdId.equals(householdId))).getSingleOrNull();
    final full = state == null || state.cursor == null || state.fullPullNeeded;
    final result = await guardApi(
      () => _api.sync.syncPull(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
        householdId: householdId,
        cursor: full ? null : state.cursor,
      ),
    );
    switch (result) {
      case Failure(failure: ApiFailure.notFound):
        // No longer a member: nothing here can reach the server any more.
        await _db.transaction(() => _db.removeHousehold(householdId));
        return null;
      case Failure(:final failure):
        return failure;
      case Success(:final value):
        await _db.transaction(
          () => _applyPull(value, full: full, userId: userId),
        );
        return null;
    }
  }

  Future<void> _applyPull(
    PullResponse pull, {
    required bool full,
    required String userId,
  }) async {
    final householdId = pull.household.id;
    await _db
        .into(_db.households)
        .insertOnConflictUpdate(_household(pull.household));
    for (final m in pull.members) {
      await _db
          .into(_db.members)
          .insertOnConflictUpdate(
            MembersCompanion.insert(
              id: m.id,
              householdId: m.householdId,
              userId: m.userId,
              displayName: m.displayName,
              joinedAt: m.joinedAt.toUtc(),
              updatedAt: m.updatedAt.toUtc(),
              deletedAt: Value(m.deletedAt?.toUtc()),
            ),
          );
    }
    for (final p in pull.plants) {
      await _db
          .into(_db.plants)
          .insertOnConflictUpdate(
            PlantsCompanion.insert(
              id: p.id,
              householdId: p.householdId,
              nickname: p.nickname ?? '',
              presetId: Value(p.presetId),
              presetVersion: Value(p.presetVersion),
              room: Value(p.room),
              photoPath: Value(p.photoPath),
              intervalSummerDays: Value(p.intervalSummerDays),
              intervalWinterDays: Value(p.intervalWinterDays),
              // A value this version doesn't know is kept as unknown (null).
              amount: Value(p.amount?.json),
              method: Value(p.method?.json),
              notes: Value(p.notes),
              createdAt: p.createdAt.toUtc(),
              updatedAt: p.updatedAt.toUtc(),
              deletedAt: Value(p.deletedAt?.toUtc()),
            ),
          );
    }
    for (final t in pull.tags) {
      final token = t.token;
      if (token == null) continue;
      // A token is unique: a local tag holding it under another id was
      // refused by the server, so the server's wins.
      await (_db.delete(
        _db.tags,
      )..where((x) => x.token.equals(token) & x.id.equals(t.id).not())).go();
      await _db
          .into(_db.tags)
          .insertOnConflictUpdate(
            TagsCompanion.insert(
              id: t.id,
              householdId: t.householdId,
              token: token,
              plantId: Value(t.plantId),
              writtenAt: Value(t.writtenAt?.toUtc()),
              writtenBy: Value(t.writtenBy),
              updatedAt: t.updatedAt.toUtc(),
              deletedAt: Value(t.deletedAt?.toUtc()),
            ),
          );
    }
    for (final w in pull.wateringEvents) {
      await _db
          .into(_db.wateringEvents)
          .insertOnConflictUpdate(
            WateringEventsCompanion.insert(
              id: w.id,
              householdId: w.householdId,
              plantId: w.plantId,
              userId: Value(w.userId),
              wateredAt: w.wateredAt.toUtc(),
              source: w.source.json ?? 'list',
              createdAt: w.createdAt.toUtc(),
              deletedAt: Value(w.deletedAt?.toUtc()),
            ),
          );
    }

    final pending = {
      for (final o in await (_db.select(
        _db.outbox,
      )..where((o) => o.householdId.equals(householdId))).get())
        o.rowId,
    };
    final pulled = {
      householdId,
      ...pull.plants.map((p) => p.id),
      ...pull.tags.map((t) => t.id),
      ...pull.wateringEvents.map((w) => w.id),
    };
    await _changes.reapplyPending(
      householdId: householdId,
      rowIds: pulled.intersection(pending),
      userId: userId,
    );

    if (full) {
      // A full pull lists every row the server has, deleted ones included:
      // anything else here was never accepted (and isn't still queued).
      final keep = {...pulled, ...pending};
      await (_db.delete(_db.plants)..where(
            (p) => p.householdId.equals(householdId) & p.id.isNotIn(keep),
          ))
          .go();
      await (_db.delete(_db.tags)..where(
            (t) => t.householdId.equals(householdId) & t.id.isNotIn(keep),
          ))
          .go();
      await (_db.delete(_db.wateringEvents)..where(
            (w) => w.householdId.equals(householdId) & w.id.isNotIn(keep),
          ))
          .go();
      await (_db.delete(_db.members)..where(
            (m) =>
                m.householdId.equals(householdId) &
                m.id.isNotIn(pull.members.map((m) => m.id)),
          ))
          .go();
    }

    await _db
        .into(_db.syncStates)
        .insertOnConflictUpdate(
          SyncStatesCompanion.insert(
            householdId: householdId,
            cursor: Value(pull.cursor),
            pulledAt: Value(_clock().toUtc()),
            fullPullNeeded: const Value(false),
          ),
        );
  }

  Future<void> _markFullPull(String householdId) => _db
      .into(_db.syncStates)
      .insert(
        SyncStatesCompanion.insert(
          householdId: householdId,
          fullPullNeeded: const Value(true),
        ),
        onConflict: DoUpdate(
          (_) => const SyncStatesCompanion(fullPullNeeded: Value(true)),
        ),
      );

  HouseholdsCompanion _household(Household h) => HouseholdsCompanion.insert(
    id: h.id,
    name: h.name,
    publicCardsEnabled: h.publicCardsEnabled,
    hemisphere: h.hemisphere.json ?? 'north',
    createdAt: h.createdAt.toUtc(),
    updatedAt: h.updatedAt.toUtc(),
    deletedAt: Value(h.deletedAt?.toUtc()),
  );
}

/// An outbox row as the contract's `PushChange`.
PushChange pushChangeOf(OutboxRow row) {
  final fields = row.fields;
  final patch = row.patch;
  return PushChange.fromJson({
    'change_id': row.changeId,
    'entity': row.entity,
    'op': row.op,
    'id': row.rowId,
    if (fields != null) 'fields': jsonDecode(fields),
    if (patch != null) row.entity: jsonDecode(patch),
  });
}
