import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// What to tell the person for each [AuthFailure]. Each message says what to
/// do next (AGENTS.md section 5).
String authFailureText(AppLocalizations l10n, AuthFailure failure) =>
    switch (failure) {
      AuthFailure.network => l10n.authErrorNetwork,
      AuthFailure.rateLimited => l10n.authErrorRateLimited,
      AuthFailure.notConfigured => l10n.authErrorNotConfigured,
      AuthFailure.cancelled || AuthFailure.unknown => l10n.authErrorUnknown,
    };
