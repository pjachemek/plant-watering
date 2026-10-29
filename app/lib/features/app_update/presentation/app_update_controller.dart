import 'package:meta/meta.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/features/app_update/data/api_version_policy_source.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'app_update_controller.g.dart';

@immutable
class AppUpdateState {
  const new({this.status = AppUpdateStatus.upToDate, this.dismissed = false});

  final AppUpdateStatus status;

  /// The recommended-update prompt was closed for this session.
  final bool dismissed;

  bool get showPrompt => status == AppUpdateStatus.recommended && !dismissed;

  @override
  bool operator ==(Object other) =>
      other is AppUpdateState &&
      other.status == status &&
      other.dismissed == dismissed;

  @override
  int get hashCode => Object.hash(status, dismissed);
}

/// Whether this app version may still be used (FR-10). Checked at start and
/// on resume, and set at once when the API answers 426. Nothing entered
/// offline is touched: it stays queued and syncs after the update.
@Riverpod(keepAlive: true)
class AppUpdateController extends _$AppUpdateController {
  @override
  AppUpdateState build() => const AppUpdateState();

  Future<void> check() async {
    final policy = await ref.read(versionPolicySourceProvider).fetch();
    if (policy == null || !ref.mounted) return;
    final status = updateStatusFor(appVersion, policy);
    state = AppUpdateState(
      status: status,
      dismissed: state.dismissed && status == AppUpdateStatus.recommended,
    );
  }

  /// The API refused this version (426).
  void upgradeRequired() =>
      state = const AppUpdateState(status: AppUpdateStatus.required);

  void dismissPrompt() =>
      state = AppUpdateState(status: state.status, dismissed: true);
}

/// The app's store listing.
final Uri storeListing = Uri.parse(
  'https://play.google.com/store/apps/details?id=pl.pampait.plantnfc',
);

/// Opens [storeListing] in the Play Store app (or the browser). Tests
/// override this.
@Riverpod(keepAlive: true)
Future<bool> Function() openStore(Ref ref) =>
    () => launchUrl(storeListing, mode: LaunchMode.externalApplication);
