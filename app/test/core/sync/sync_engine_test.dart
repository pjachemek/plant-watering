// Needs SQLite: run in Docker on Windows with Smart App Control (README).
@Tags(['database'])
library;

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/database/local_changes.dart';
import 'package:plantnfc/core/sync/sync_engine.dart';

import '../../helpers/fake_sync_server.dart';

const String home = '0192f3c4-0000-7000-8000-000000000001';
const String ann = '0192f3c4-0000-7000-8000-0000000000a1';
const String bob = '0192f3c4-0000-7000-8000-0000000000b2';
const String monty = '0192f3c4-0000-7000-8000-000000000101';

/// One phone: its own database, outbox and engine.
class Device {
  new(this.server, this.userId) {
    db = AppDatabase(NativeDatabase.memory());
    changes = LocalChanges(db);
    engine = SyncEngine(
      db: db,
      api: server.clientFor(userId),
      changes: changes,
    );
  }

  final FakeSyncServer server;
  final String userId;
  late final AppDatabase db;
  late final LocalChanges changes;
  late final SyncEngine engine;

  Future<ApiFailure?> sync() => engine.syncAll(userId: userId);

  Future<void> change(LocalChange change) =>
      changes.record(change, userId: userId);

  Future<void> editPlant(Map<String, Object?> patch, {String id = monty}) =>
      change(
        LocalChange(
          householdId: home,
          entity: ChangeEntity.plant,
          op: ChangeOp.upsert,
          rowId: id,
          patch: patch,
        ),
      );

  Future<void> water(String id, String at) => change(
    LocalChange(
      householdId: home,
      entity: ChangeEntity.wateringEvent,
      op: ChangeOp.upsert,
      rowId: id,
      patch: {'plant_id': monty, 'watered_at': at, 'source': 'scan'},
    ),
  );

  Future<PlantRow?> plant([String id = monty]) =>
      (db.select(db.plants)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<OutboxRow>> outbox() => db.select(db.outbox).get();

  Future<List<WateringEventRow>> waterings() => (db.select(
    db.wateringEvents,
  )..orderBy([(w) => OrderingTerm(expression: w.wateredAt)])).get();
}

void main() {
  late FakeSyncServer server;
  late Device a;
  late Device b;

  setUp(() async {
    server = FakeSyncServer(householdId: home);
    a = Device(server, ann);
    b = Device(server, bob);
    // Both phones start in step with an empty household.
    expect(await a.sync(), isNull);
    expect(await b.sync(), isNull);
  });

  tearDown(() async {
    await a.db.close();
    await b.db.close();
  });

  test(
    'pushes queued changes in order, then the other phone pulls them',
    () async {
      await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});
      await a.water('w1', '2026-10-29T07:00:00.000Z');

      expect(await a.sync(), isNull);
      expect(await a.outbox(), isEmpty);
      expect(server.plants[monty]?['nickname'], 'Monty');

      expect(await b.sync(), isNull);
      expect((await b.plant())?.nickname, 'Monty');
      expect((await b.waterings()).single.userId, ann);
    },
  );

  test(
    'a lost answer is retried with the same key and nothing doubles',
    () async {
      await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});
      await a.water('w1', '2026-10-29T07:00:00.000Z');

      // The server applies the push, but the answer never arrives.
      server.loseNextPushAnswer = true;
      expect(await a.sync(), ApiFailure.network);
      final queued = await a.outbox();
      expect(queued, hasLength(2));
      expect(queued.map((o) => o.attempts), [1, 1]);
      final key = queued.first.batchKey;
      expect(key, isNotNull);

      expect(await a.sync(), isNull);

      // Same request, same key: the server answers from its ledger.
      expect(server.pushKeys, [key, key]);
      expect(server.waterings, hasLength(1));
      expect(await a.outbox(), isEmpty);
      expect((await a.waterings()).single.id, 'w1');
    },
  );

  test('changes queued after a lost answer go in a later batch', () async {
    await a.water('w1', '2026-10-29T07:00:00.000Z');
    server.loseNextPushAnswer = true;
    await a.sync();
    await a.water('w2', '2026-10-29T08:00:00.000Z');

    expect(await a.sync(), isNull);

    expect(server.pushKeys, hasLength(3));
    expect(server.pushKeys[0], server.pushKeys[1]);
    expect(server.pushKeys[2], isNot(server.pushKeys[0]));
    expect(server.waterings.keys, unorderedEquals(['w1', 'w2']));
  });

  test(
    'two phones edit offline, reconnect, and agree (section 5 rules)',
    () async {
      await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});
      await a.sync();
      await b.sync();

      // Offline on both: different fields of the same plant, and a watering
      // each.
      server.offline = true;
      await a.editPlant({'room': 'Kitchen'});
      await b.editPlant({'nickname': 'Big Monty'});
      await a.water('wa', '2026-10-29T07:00:00.000Z');
      await b.water('wb', '2026-10-29T07:05:00.000Z');
      server.offline = false;

      await a.sync();
      await b.sync();
      await a.sync();

      for (final device in [a, b]) {
        final plant = await device.plant();
        expect(plant?.nickname, 'Big Monty');
        expect(plant?.room, 'Kitchen');
        expect((await device.waterings()).map((w) => w.id), ['wa', 'wb']);
        expect(await device.outbox(), isEmpty);
      }
    },
  );

  test('an edit made during a sync stays on screen until it is sent', () async {
    await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});
    await a.sync();
    await b.editPlant({'nickname': 'Server name'});
    await b.sync();

    // The person renames the plant while the pull is on its way.
    server.beforePull = () {
      server.beforePull = null;
      a.editPlant({'nickname': 'My name'}).ignore();
    };
    await a.sync();
    expect((await a.plant())?.nickname, 'My name');

    await a.sync();
    expect(server.plants[monty]?['nickname'], 'My name');
  });

  test('a change the server rejects disappears after a full pull', () async {
    // A custom plant without intervals breaks the server's rules.
    await a.editPlant({'nickname': 'Odd'}, id: 'odd');
    expect((await a.plant('odd'))?.nickname, 'Odd');

    expect(await a.sync(), isNull);

    expect(await a.plant('odd'), isNull);
    expect(await a.outbox(), isEmpty);
    final state = await a.db.select(a.db.syncStates).getSingle();
    expect(state.fullPullNeeded, isFalse);
  });

  test(
    'a sticker linked again after deleting its tag syncs on both phones',
    () async {
      final token = 'R' * 22;
      LocalChange tag(String id, ChangeOp op) => LocalChange(
        householdId: home,
        entity: ChangeEntity.tag,
        op: op,
        rowId: id,
        patch: op == ChangeOp.upsert ? {'token': token} : const {},
      );
      await a.change(tag('t1', ChangeOp.upsert));
      await a.change(tag('t1', ChangeOp.delete));
      await a.change(tag('t2', ChangeOp.upsert)); // same sticker, new tag

      expect(await a.sync(), isNull);
      expect(await b.sync(), isNull);

      for (final device in [a, b]) {
        final tags = {
          for (final t in await device.db.select(device.db.tags).get()) t.id: t,
        };
        expect(tags['t1']?.deletedAt, isNotNull);
        expect(tags['t2']?.deletedAt, isNull);
        expect(tags['t2']?.token, token);
      }
    },
  );

  test('leaving the household removes its data from the phone', () async {
    await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});
    await a.sync();

    server.memberOf = [];
    expect(await a.sync(), isNull);

    expect(await a.db.select(a.db.households).get(), isEmpty);
    expect(await a.plant(), isNull);
  });

  test('a change queued for a household already left is dropped', () async {
    // Seen on a Pixel: a plant added while leaving stayed queued forever.
    await a.change(
      const LocalChange(
        householdId: 'gone',
        entity: ChangeEntity.plant,
        op: ChangeOp.upsert,
        rowId: 'p-gone',
        patch: {'nickname': 'Orphan', 'preset_id': 'monstera'},
      ),
    );

    expect(await a.sync(), isNull);

    expect(await a.outbox(), isEmpty);
    expect(await a.plant('p-gone'), isNull);
  });

  test('offline, everything stays queued and readable', () async {
    server.offline = true;
    await a.editPlant({'nickname': 'Monty', 'preset_id': 'monstera'});

    expect(await a.sync(), ApiFailure.network);

    expect((await a.plant())?.nickname, 'Monty');
    expect(await a.outbox(), hasLength(1));
  });
}
