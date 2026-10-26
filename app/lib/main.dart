import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/app.dart';
import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/observability/error_reporting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  await runWithErrorReporting(
    config,
    () => runApp(const ProviderScope(child: PlantApp())),
  );
}
