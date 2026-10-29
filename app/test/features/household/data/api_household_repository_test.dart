// Needs SQLite: run in Docker on Windows with Smart App Control (README).
@Tags(['database'])
library;

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/domain/household.dart';

import '../../../helpers/fake_http_adapter.dart';

const String home = '0192f3c4-0000-7000-8000-000000000001';

Map<String, Object?> householdJson({String name = 'Our home'}) => {
  'id': home,
  'name': name,
  'public_cards_enabled': false,
  'hemisphere': 'north',
  'created_at': '2026-10-29T08:00:00.000Z',
  'updated_at': '2026-10-29T08:00:00.000Z',
};

void main() {
  late AppDatabase db;
  late FakeHttpAdapter http;
  late ApiHouseholdRepository repository;
  late int syncs;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    http = FakeHttpAdapter((_) => (200, householdJson()));
    syncs = 0;
    repository = ApiHouseholdRepository(
      api: PlantApiClient(
        Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
          ..httpClientAdapter = http,
      ),
      db: db,
      requestSync: () => syncs++,
    );
  });

  tearDown(() => db.close());

  test('creating saves the household here and syncs the rest', () async {
    http.respond = (_) => (201, householdJson());

    final result = await repository.create(
      name: 'Our home',
      displayName: 'Ann',
    );

    expect(result, const Success<void, HouseholdFailure>(null));
    expect(http.requests.single.path, '/households');
    expect(http.requests.single.data.toString(), contains('display_name'));
    expect(syncs, 1);
    final current = await repository.watchCurrent().first;
    expect(current?.name, 'Our home');
  });

  test('the current household comes with its members, live', () async {
    await repository.create(name: 'Our home', displayName: 'Ann');
    final updates = repository.watchCurrent();

    await db
        .into(db.members)
        .insert(
          MembersCompanion.insert(
            id: 'm1',
            householdId: home,
            userId: 'u1',
            displayName: 'Ann',
            joinedAt: DateTime.utc(2026, 10, 29),
            updatedAt: DateTime.utc(2026, 10, 29),
          ),
        );

    expect(
      await updates.firstWhere((h) => h?.members.isNotEmpty ?? false),
      isA<HouseholdSummary>().having(
        (h) => h.members.single.displayName,
        'member',
        'Ann',
      ),
    );
  });

  test('joining with a refused code says so; offline says so', () async {
    http.respond = (_) =>
        (404, {'type': 'not_found', 'title': 'x', 'status': 404});
    expect(
      await repository.join(code: 'Ab3dEf6hIj9k', displayName: 'Bob'),
      const Failure<void, HouseholdFailure>(HouseholdFailure.invalidCode),
    );

    http.respond = (r) => throw DioException.connectionError(
      requestOptions: r,
      reason: 'offline',
    );
    expect(
      await repository.join(code: 'Ab3dEf6hIj9k', displayName: 'Bob'),
      const Failure<void, HouseholdFailure>(HouseholdFailure.network),
    );
    expect(syncs, 0);
    expect(await repository.watchCurrent().first, isNull);
  });

  test('an invite returns the code, link and expiry', () async {
    http.respond = (_) => (
      201,
      {
        'code': 'Ab3dEf6hIj9k',
        'url': 'https://plants.pampait.pl/i/Ab3dEf6hIj9k',
        'expires_at': '2026-11-05T08:00:00.000Z',
      },
    );

    final invite = (await repository.invite(home)).valueOrNull;

    expect(invite?.code, 'Ab3dEf6hIj9k');
    expect(invite?.link.path, '/i/Ab3dEf6hIj9k');
    expect(invite?.expiresAt, DateTime.utc(2026, 11, 5, 8));
  });

  test('leaving removes the household from the phone', () async {
    await repository.create(name: 'Our home', displayName: 'Ann');
    http.respond = (_) => (204, null);

    expect(
      await repository.leave(home, confirmDelete: false),
      const Success<void, HouseholdFailure>(null),
    );
    expect(await repository.watchCurrent().first, isNull);
  });

  test('leaving shows at once, while the members query is live', () async {
    // Seen on a Pixel: the household stayed on screen after leaving.
    await repository.create(name: 'Our home', displayName: 'Ann');
    await db
        .into(db.members)
        .insert(
          MembersCompanion.insert(
            id: 'm1',
            householdId: home,
            userId: 'u1',
            displayName: 'Ann',
            joinedAt: DateTime.utc(2026, 10, 29),
            updatedAt: DateTime.utc(2026, 10, 29),
          ),
        );
    final seen = <HouseholdSummary?>[];
    final sub = repository.watchCurrent().listen(seen.add);
    addTearDown(sub.cancel);
    await pumpEventQueue();
    expect(seen.last?.name, 'Our home');

    http.respond = (_) => (204, null);
    await repository.leave(home, confirmDelete: true);
    await pumpEventQueue();

    expect(seen.last, isNull);
  });

  test('the last member is asked to confirm, and nothing is removed', () async {
    await repository.create(name: 'Our home', displayName: 'Ann');
    http.respond = (_) =>
        (409, {'type': 'confirmation_required', 'title': 'x', 'status': 409});

    expect(
      await repository.leave(home, confirmDelete: false),
      const Failure<void, HouseholdFailure>(
        HouseholdFailure.confirmationRequired,
      ),
    );
    expect(await repository.watchCurrent().first, isNotNull);
  });
}
