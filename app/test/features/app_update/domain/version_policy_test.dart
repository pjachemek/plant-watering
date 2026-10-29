import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';

void main() {
  test('compares dotted versions by number, not by text', () {
    expect(compareVersions('1.10.0', '1.9.3'), greaterThan(0));
    expect(compareVersions('0.1.0', '0.1.0'), 0);
    expect(compareVersions('0.1', '0.1.0'), 0);
    expect(compareVersions('2.0.0', '10.0.0'), lessThan(0));
    expect(compareVersions('1.x.0', '1.0.0'), 0); // malformed parts are 0
  });

  test('decides between up to date, recommended and required', () {
    const policy = VersionPolicy(
      minVersion: '1.2.0',
      recommendedVersion: '1.4.0',
    );

    expect(updateStatusFor('1.1.9', policy), AppUpdateStatus.required);
    expect(updateStatusFor('1.2.0', policy), AppUpdateStatus.recommended);
    expect(updateStatusFor('1.3.5', policy), AppUpdateStatus.recommended);
    expect(updateStatusFor('1.4.0', policy), AppUpdateStatus.upToDate);
    expect(updateStatusFor('2.0.0', policy), AppUpdateStatus.upToDate);
  });
}
