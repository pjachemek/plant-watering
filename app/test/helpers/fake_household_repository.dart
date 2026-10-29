import 'dart:async';

import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/household/domain/household.dart';

/// A [HouseholdRepository] for widget tests. Starts with a current
/// household by default and records what was asked.
class FakeHouseholdRepository implements HouseholdRepository {
  new({this._current = home});

  static const HouseholdSummary home = HouseholdSummary(
    id: '0192f3c4-0000-7000-8000-000000000001',
    name: 'Our home',
    members: [
      HouseholdMember(userId: 'u1', displayName: 'Ann'),
      HouseholdMember(userId: 'u2', displayName: 'Bob'),
    ],
  );

  HouseholdSummary? _current;
  final StreamController<HouseholdSummary?> _changes =
      StreamController<HouseholdSummary?>.broadcast();

  Result<void, HouseholdFailure> createResult = const Success(null);
  Result<void, HouseholdFailure> joinResult = const Success(null);
  Result<InviteCode, HouseholdFailure> inviteResult = Success(
    InviteCode(
      code: 'Ab3dEf6hIj9k',
      link: Uri.parse('https://plants.pampait.pl/i/Ab3dEf6hIj9k'),
      expiresAt: DateTime.utc(2026, 11, 5),
    ),
  );

  /// Answers for successive leave calls; the last one repeats.
  List<Result<void, HouseholdFailure>> leaveResults = [const Success(null)];

  final List<({String name, String displayName})> created = [];
  final List<({String code, String displayName})> joined = [];
  final List<bool> leaves = [];

  void _set(HouseholdSummary? value) {
    _current = value;
    _changes.add(value);
  }

  @override
  Stream<HouseholdSummary?> watchCurrent() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<Result<void, HouseholdFailure>> create({
    required String name,
    required String displayName,
  }) async {
    created.add((name: name, displayName: displayName));
    if (createResult.isSuccess) {
      _set(
        HouseholdSummary(
          id: home.id,
          name: name,
          members: [HouseholdMember(userId: 'me', displayName: displayName)],
        ),
      );
    }
    return createResult;
  }

  @override
  Future<Result<void, HouseholdFailure>> join({
    required String code,
    required String displayName,
  }) async {
    joined.add((code: code, displayName: displayName));
    if (joinResult.isSuccess) _set(home);
    return joinResult;
  }

  @override
  Future<Result<InviteCode, HouseholdFailure>> invite(String id) async =>
      inviteResult;

  @override
  Future<Result<void, HouseholdFailure>> leave(
    String id, {
    required bool confirmDelete,
  }) async {
    leaves.add(confirmDelete);
    final result = leaveResults.length > 1
        ? leaveResults.removeAt(0)
        : leaveResults.single;
    if (result.isSuccess) _set(null);
    return result;
  }
}
