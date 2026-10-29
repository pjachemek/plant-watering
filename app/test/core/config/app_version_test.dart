import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/config/app_version.dart';

void main() {
  test('matches the version name in pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(\d+\.\d+\.\d+)',
      multiLine: true,
    ).firstMatch(pubspec)?.group(1);

    expect(appVersion, version);
  });
}
