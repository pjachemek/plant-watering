import 'package:drift/drift.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/api/api_providers.dart';
import 'package:plantnfc/core/api/generated/models/accept_invite_request.dart';
import 'package:plantnfc/core/api/generated/models/create_household_request.dart';
import 'package:plantnfc/core/api/generated/models/household.dart';
import 'package:plantnfc/core/api/generated/models/households_household_id_leave_request_body.dart';
import 'package:plantnfc/core/api/generated/models/invites_request_body.dart';
import 'package:plantnfc/core/api/generated/models/platform.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/household/domain/household.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_household_repository.g.dart';

/// Households (FR-7). Reads come from the local database, so they work
/// offline; creating, inviting, joining and leaving go to the API, then
/// sync fills in the rest.
class ApiHouseholdRepository implements HouseholdRepository {
  new({required this._api, required this._db, required this._requestSync});

  final PlantApiClient _api;
  final AppDatabase _db;
  final void Function() _requestSync;

  @override
  Stream<HouseholdSummary?> watchCurrent() {
    final household =
        (_db.select(_db.households)
              ..where((h) => h.deletedAt.isNull())
              ..orderBy([(h) => OrderingTerm(expression: h.createdAt)])
              ..limit(1))
            .watchSingleOrNull();
    return household.asyncExpand((row) {
      if (row == null) return Stream.value(null);
      return (_db.select(_db.members)
            ..where((m) => m.householdId.equals(row.id) & m.deletedAt.isNull())
            ..orderBy([(m) => OrderingTerm(expression: m.joinedAt)]))
          .watch()
          .map(
            (members) => HouseholdSummary(
              id: row.id,
              name: row.name,
              members: [
                for (final m in members)
                  HouseholdMember(userId: m.userId, displayName: m.displayName),
              ],
            ),
          );
    });
  }

  @override
  Future<Result<void, HouseholdFailure>> create({
    required String name,
    required String displayName,
  }) => _joined(
    () => _api.households.createHousehold(
      xAppVersion: appVersion,
      xPlatform: Platform.android,
      xApiVersion: ApiHeadersInterceptor.apiVersion,
      body: CreateHouseholdRequest(name: name, displayName: displayName),
    ),
  );

  @override
  Future<Result<void, HouseholdFailure>> join({
    required String code,
    required String displayName,
  }) => _joined(
    () => _api.invites.acceptInvite(
      xAppVersion: appVersion,
      xPlatform: Platform.android,
      xApiVersion: ApiHeadersInterceptor.apiVersion,
      body: AcceptInviteRequest(code: code, displayName: displayName),
    ),
    notFound: HouseholdFailure.invalidCode,
  );

  /// Saves the household the API returned, then syncs the rest (members,
  /// plants) at once.
  Future<Result<void, HouseholdFailure>> _joined(
    Future<Household> Function() call, {
    HouseholdFailure notFound = HouseholdFailure.notFound,
  }) async {
    final result = await guardApi(call);
    switch (result) {
      case Failure(:final failure):
        return Failure(_failure(failure, notFound: notFound));
      case Success(value: final h):
        await _db
            .into(_db.households)
            .insertOnConflictUpdate(
              HouseholdsCompanion.insert(
                id: h.id,
                name: h.name,
                publicCardsEnabled: h.publicCardsEnabled,
                hemisphere: h.hemisphere.json ?? 'north',
                createdAt: h.createdAt.toUtc(),
                updatedAt: h.updatedAt.toUtc(),
              ),
            );
        _requestSync();
        return const Success(null);
    }
  }

  @override
  Future<Result<InviteCode, HouseholdFailure>> invite(
    String householdId,
  ) async {
    final result = await guardApi(
      () => _api.invites.createInvite(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
        body: InvitesRequestBody(householdId: householdId),
      ),
    );
    return switch (result) {
      Success(:final value) => Success(
        InviteCode(
          code: value.code,
          link: Uri.parse(value.url),
          expiresAt: value.expiresAt.toUtc(),
        ),
      ),
      Failure(:final failure) => Failure(_failure(failure)),
    };
  }

  @override
  Future<Result<void, HouseholdFailure>> leave(
    String householdId, {
    required bool confirmDelete,
  }) async {
    final result = await guardApi(
      () => _api.households.leaveHousehold(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
        householdId: householdId,
        body: HouseholdsHouseholdIdLeaveRequestBody(
          confirmDeleteHousehold: confirmDelete,
        ),
      ),
    );
    switch (result) {
      case Success() || Failure(failure: ApiFailure.notFound):
        // Left, or already gone: nothing of it stays on this phone.
        await _db.removeHousehold(householdId);
        return const Success(null);
      case Failure(:final failure):
        return Failure(_failure(failure));
    }
  }

  HouseholdFailure _failure(
    ApiFailure failure, {
    HouseholdFailure notFound = HouseholdFailure.notFound,
  }) => switch (failure) {
    ApiFailure.network ||
    ApiFailure.server ||
    ApiFailure.rateLimited => HouseholdFailure.network,
    ApiFailure.notFound => notFound,
    ApiFailure.conflict => HouseholdFailure.confirmationRequired,
    ApiFailure.unauthorized ||
    ApiFailure.upgradeRequired ||
    ApiFailure.badRequest => HouseholdFailure.unknown,
  };
}

/// Tests override this with a fake.
@Riverpod(keepAlive: true)
HouseholdRepository householdRepository(Ref ref) => ApiHouseholdRepository(
  api: ref.watch(plantApiProvider),
  db: ref.watch(appDatabaseProvider),
  requestSync: () => ref.read(syncControllerProvider.notifier).requestSync(),
);

/// The household on this phone, live.
@riverpod
Stream<HouseholdSummary?> currentHousehold(Ref ref) =>
    ref.watch(householdRepositoryProvider).watchCurrent();
