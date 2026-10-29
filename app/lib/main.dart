import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/app.dart';
import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/observability/error_reporting.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  await runWithErrorReporting(config, () async {
    final container = ProviderContainer();
    // Known before the first frame, from secure storage and without network,
    // so a signed-in cold start from a tag never passes the sign-in screen.
    await container.read(authRepositoryProvider).restore();
    runApp(
      UncontrolledProviderScope(container: container, child: const PlantApp()),
    );
  });
}
