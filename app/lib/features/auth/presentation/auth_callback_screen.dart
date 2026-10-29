import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/presentation/auth_failure_text.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Target of the email sign-in link (`/auth/callback?code=…`, ADR-0021).
/// Exchanges the code for a session; on success the router moves on.
class AuthCallbackScreen extends ConsumerStatefulWidget {
  const new({required this.code, super.key});

  /// The one-time code from the link; `null` when the link carried an error
  /// instead (for example an expired link).
  final String? code;

  @override
  ConsumerState<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<AuthCallbackScreen> {
  AuthFailure? _failure;

  @override
  void initState() {
    super.initState();
    final code = widget.code;
    if (code == null || code.isEmpty) {
      _failure = AuthFailure.linkInvalid;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _complete(code));
    }
  }

  Future<void> _complete(String code) async {
    final result = await ref
        .read(authRepositoryProvider)
        .completeEmailLink(code);
    if (!mounted) return;
    if (result case Failure(:final failure)) {
      setState(() => _failure = failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = _failure;
    if (failure == null) {
      return Scaffold(
        body: Semantics(
          label: l10n.authCallbackTitle,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return Scaffold(
      body: MessageView(
        icon: Icons.link_off,
        iconLabel: l10n.authCallbackFailedTitle,
        title: l10n.authCallbackFailedTitle,
        body: authFailureText(l10n, failure),
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.signIn),
          child: Text(l10n.backToSignInAction),
        ),
      ),
    );
  }
}
