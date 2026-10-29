import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/design/app_theme.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/app_update/presentation/app_update_controller.dart';
import 'package:plantnfc/features/app_update/presentation/update_required_screen.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

class PlantApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PlantApp> createState() => _PlantAppState();
}

class _PlantAppState extends ConsumerState<PlantApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Version policy at start and on every resume (FR-10). Offline, nothing
    // changes; there is no polling (NFR Battery).
    _lifecycle = AppLifecycleListener(onResume: _checkVersion);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVersion());
  }

  void _checkVersion() =>
      unawaited(ref.read(appUpdateControllerProvider.notifier).check());

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) =>
          UpdatePrompt(child: child ?? const SizedBox()),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
