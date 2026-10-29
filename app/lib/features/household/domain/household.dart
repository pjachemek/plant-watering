import 'package:meta/meta.dart';
import 'package:plantnfc/core/result/result.dart';

/// The household the app shows, with its current members (FR-7).
@immutable
class HouseholdSummary {
  const new({required this.id, required this.name, required this.members});

  final String id;
  final String name;
  final List<HouseholdMember> members;
}

@immutable
class HouseholdMember {
  const new({required this.userId, required this.displayName});

  final String userId;
  final String displayName;
}

/// A new invite, shown once: only its hash is stored (ADR-0018).
@immutable
class InviteCode {
  const new({required this.code, required this.link, required this.expiresAt});

  final String code;
  final Uri link;
  final DateTime expiresAt;
}

enum HouseholdFailure {
  /// No connection: creating, inviting, joining and leaving need the server.
  network,

  /// The invite code is unknown, used or expired (the API doesn't say which).
  invalidCode,

  /// The last member must confirm that leaving deletes the household.
  confirmationRequired,

  /// The household is gone, or this person is no longer in it.
  notFound,

  unknown,
}

abstract interface class HouseholdRepository {
  /// The household on this phone (the oldest if there are several), or
  /// `null` before creating or joining one. Updates as sync brings changes.
  Stream<HouseholdSummary?> watchCurrent();

  Future<Result<void, HouseholdFailure>> create({
    required String name,
    required String displayName,
  });

  Future<Result<InviteCode, HouseholdFailure>> invite(String householdId);

  Future<Result<void, HouseholdFailure>> join({
    required String code,
    required String displayName,
  });

  Future<Result<void, HouseholdFailure>> leave(
    String householdId, {
    required bool confirmDelete,
  });
}

/// Invite codes: 12 base62 characters (ADR-0018).
final RegExp _code = RegExp(r'^[0-9A-Za-z]{12}$');

/// The code from what a person typed or pasted: the code itself, or an
/// invite link (`https://plants.pampait.pl/i/{code}`). `null` when it can't
/// be one. Case matters, so it is kept as typed.
String? parseInviteCode(String input) {
  final text = input.trim();
  if (_code.hasMatch(text)) return text;
  final uri = Uri.tryParse(text);
  if (uri == null || uri.host != 'plants.pampait.pl') return null;
  final segments = uri.pathSegments;
  if (segments.length == 2 &&
      segments.first == 'i' &&
      _code.hasMatch(segments.last)) {
    return segments.last;
  }
  return null;
}

/// A name as stored: trimmed; `null` when empty or longer than [max].
String? cleanName(String input, {required int max}) {
  final text = input.trim();
  return text.isEmpty || text.length > max ? null : text;
}
