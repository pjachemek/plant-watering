import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/database/local_changes.dart';

const String home = '0192f3c4-0000-7000-8000-000000000001';
const String ann = '0192f3c4-0000-7000-8000-0000000000a1';
const String monty = '0192f3c4-0000-7000-8000-000000000101';

void main() {
  late AppDatabase db;
  late LocalChanges changes;
  var ids = 0;
  final now = DateTime.utc(2026, 10, 29, 8);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    ids = 0;
    changes = LocalChanges(
      db,
      clock: () => now,
      newId: () => 'change-${++ids}',
    );
    await db
        .into(db.households)
        .insert(
          HouseholdsCompanion.insert(
            id: home,
            name: 'Home',
            publicCardsEnabled: false,
            hemisphere: 'north',
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  tearDown(() => db.close());

  Future<String> addMonty() => changes.record(
    const LocalChange(
      householdId: home,
      entity: ChangeEntity.plant,
      op: ChangeOp.upsert,
      rowId: monty,
      patch: {'nickname': 'Monty', 'preset_id': 'monstera'},
    ),
    userId: ann,
  );

  Future<List<OutboxRow>> outbox() => (db.select(
    db.outbox,
  )..orderBy([(o) => OrderingTerm(expression: o.seq)])).get();

  Future<PlantRow> plant(String id) =>
      (db.select(db.plants)..where((p) => p.id.equals(id))).getSingle();

  test('a new plant is saved and queued in the contract shape', () async {
    final changeId = await addMonty();

    final saved = await plant(monty);
    expect(saved.nickname, 'Monty');
    expect(saved.presetId, 'monstera');
    expect(saved.room, isNull);
    expect(saved.createdAt, now);

    final queued = (await outbox()).single;
    expect(queued.changeId, changeId);
    expect(queued.entity, 'plant');
    expect(queued.op, 'upsert');
    expect(queued.rowId, monty);
    expect(jsonDecode(queued.fields!), ['nickname', 'preset_id']);
    expect(jsonDecode(queued.patch!), {
      'nickname': 'Monty',
      'preset_id': 'monstera',
    });
    expect(queued.batchKey, isNull);
  });

  test(
    'an edit changes only the listed fields; a listed absent one clears',
    () async {
      await addMonty();
      await changes.record(
        const LocalChange(
          householdId: home,
          entity: ChangeEntity.plant,
          op: ChangeOp.upsert,
          rowId: monty,
          patch: {'room': 'Kitchen'},
        ),
        userId: ann,
      );
      expect((await plant(monty)).room, 'Kitchen');

      await changes.record(
        const LocalChange(
          householdId: home,
          entity: ChangeEntity.plant,
          op: ChangeOp.upsert,
          rowId: monty,
          fields: ['room'],
        ),
        userId: ann,
      );

      final saved = await plant(monty);
      expect(saved.room, isNull);
      expect(saved.nickname, 'Monty');
      expect((await outbox()).map((o) => o.seq), [1, 2, 3]);
    },
  );

  test('waterings are logged as the user, once per id, and undone', () async {
    await addMonty();
    const water = LocalChange(
      householdId: home,
      entity: ChangeEntity.wateringEvent,
      op: ChangeOp.upsert,
      rowId: 'w1',
      patch: {
        'plant_id': monty,
        'watered_at': '2026-10-29T07:30:00.000Z',
        'source': 'scan',
      },
    );
    await changes.record(water, userId: ann);
    await changes.record(water, userId: ann);

    final events = await db.select(db.wateringEvents).get();
    expect(events.single.userId, ann);
    expect(events.single.wateredAt, DateTime.utc(2026, 10, 29, 7, 30));

    await changes.record(
      const LocalChange(
        householdId: home,
        entity: ChangeEntity.wateringEvent,
        op: ChangeOp.delete,
        rowId: 'w1',
      ),
      userId: ann,
    );
    expect((await db.select(db.wateringEvents).getSingle()).deletedAt, now);

    final queued = await outbox();
    expect(queued.map((o) => o.op), ['upsert', 'upsert', 'upsert', 'delete']);
    expect(queued[1].fields, isNull); // waterings are created whole
    expect(queued.last.patch, isNull);
  });

  test('a new tag link moves the plant off its old tag', () async {
    await addMonty();
    for (final (id, token) in [('t1', 'A' * 22), ('t2', 'B' * 22)]) {
      await changes.record(
        LocalChange(
          householdId: home,
          entity: ChangeEntity.tag,
          op: ChangeOp.upsert,
          rowId: id,
          patch: {
            'token': token,
            'plant_id': monty,
            'written_at': '2026-10-29T08:00:00.000Z',
          },
        ),
        userId: ann,
      );
    }

    final tags = {for (final t in await db.select(db.tags).get()) t.id: t};
    expect(tags['t1']!.plantId, isNull);
    expect(tags['t2']!.plantId, monty);
    expect(tags['t2']!.writtenBy, ann);
  });

  test('deleting a plant soft-deletes it and frees its tag', () async {
    await addMonty();
    await changes.record(
      LocalChange(
        householdId: home,
        entity: ChangeEntity.tag,
        op: ChangeOp.upsert,
        rowId: 't1',
        patch: {'token': 'C' * 22, 'plant_id': monty},
      ),
      userId: ann,
    );

    await changes.record(
      const LocalChange(
        householdId: home,
        entity: ChangeEntity.plant,
        op: ChangeOp.delete,
        rowId: monty,
      ),
      userId: ann,
    );

    expect((await plant(monty)).deletedAt, now);
    expect((await db.select(db.tags).getSingle()).plantId, isNull);
  });

  test('changes household settings, never deletes the household', () async {
    await changes.record(
      const LocalChange(
        householdId: home,
        entity: ChangeEntity.household,
        op: ChangeOp.upsert,
        rowId: home,
        patch: {'hemisphere': 'south'},
      ),
      userId: ann,
    );
    expect((await db.select(db.households).getSingle()).hemisphere, 'south');

    await expectLater(
      changes.record(
        const LocalChange(
          householdId: home,
          entity: ChangeEntity.household,
          op: ChangeOp.delete,
          rowId: home,
        ),
        userId: ann,
      ),
      throwsArgumentError,
    );
  });

  test(
    'a change that fails leaves neither the row nor the outbox entry',
    () async {
      // A new plant without a nickname breaks the table's NOT NULL rule.
      await expectLater(
        changes.record(
          const LocalChange(
            householdId: home,
            entity: ChangeEntity.plant,
            op: ChangeOp.upsert,
            rowId: monty,
            patch: {'room': 'Hall'},
          ),
          userId: ann,
        ),
        throwsA(anything),
      );

      expect(await db.select(db.plants).get(), isEmpty);
      expect(await outbox(), isEmpty);
    },
  );

  test('clearAll removes every household and the outbox', () async {
    await addMonty();

    await db.clearAll();

    expect(await db.select(db.households).get(), isEmpty);
    expect(await db.select(db.plants).get(), isEmpty);
    expect(await outbox(), isEmpty);
  });
}
