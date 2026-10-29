import 'package:meta/meta.dart';

/// Minimum and recommended app versions for this platform, from the API
/// (FR-10). The minimum can change without an app release.
@immutable
class VersionPolicy {
  const new({required this.minVersion, required this.recommendedVersion});

  final String minVersion;
  final String recommendedVersion;
}

enum AppUpdateStatus {
  upToDate,

  /// A newer version is recommended: a dismissible prompt.
  recommended,

  /// Below the minimum: a blocking screen until the app is updated.
  required,
}

/// Where [current] stands against [policy].
AppUpdateStatus updateStatusFor(String current, VersionPolicy policy) {
  if (compareVersions(current, policy.minVersion) < 0) {
    return AppUpdateStatus.required;
  }
  if (compareVersions(current, policy.recommendedVersion) < 0) {
    return AppUpdateStatus.recommended;
  }
  return AppUpdateStatus.upToDate;
}

/// Compares dotted numeric versions (`1.10.0` > `1.9.3`). Missing or
/// non-numeric parts count as 0, so a malformed value never crashes.
int compareVersions(String a, String b) {
  List<int> parts(String v) =>
      v.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final left = parts(a);
  final right = parts(b);
  for (var i = 0; i < 3; i++) {
    final l = i < left.length ? left[i] : 0;
    final r = i < right.length ? right[i] : 0;
    if (l != r) return l.compareTo(r);
  }
  return 0;
}

/// Reads the current [VersionPolicy]; `null` when it can't be read now
/// (offline), in which case nothing changes.
abstract interface class VersionPolicySource {
  Future<VersionPolicy?> fetch();
}
