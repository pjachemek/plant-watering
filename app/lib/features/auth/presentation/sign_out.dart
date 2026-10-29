import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out.g.dart';

/// Signs out and removes this account's household data from the phone, so
/// the next person to sign in here never sees it (ADR-0024, ADR-0026).
/// Tests override it.
@Riverpod(keepAlive: true)
Future<void> Function() signOutAndClear(Ref ref) => () async {
  await ref.read(authRepositoryProvider).signOut();
  await ref.read(appDatabaseProvider).clearAll();
};

/// Signs out, after a warning when changes made on this phone haven't
/// reached the server: signing out deletes them.
Future<void> confirmSignOut(BuildContext context, WidgetRef ref) async {
  final pending = ref.read(outboxSizeProvider).value ?? 0;
  if (pending > 0) {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(l10n.signOutPendingTitle),
        content: Text(l10n.signOutPendingBody(pending)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signOutAnywayAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
  }
  await ref.read(signOutAndClearProvider)();
}
