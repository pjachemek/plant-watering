import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Target of `/p/:tagToken` (FR-1). In M0/M1 it only proves the deep link
/// lands here; M4 resolves the token to a plant card.
class TagScreen extends StatelessWidget {
  const new({required this.tagToken, super.key});

  /// Never shown or logged: it is a bearer secret for the public card.
  final String tagToken;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tagOpeningTitle)),
      body: MessageView(
        icon: Icons.nfc,
        iconLabel: l10n.tagOpeningTitle,
        title: l10n.tagOpeningTitle,
        body: l10n.tagOpeningBody,
        action: OutlinedButton(
          onPressed: () => context.go(AppRoutes.plants),
          child: Text(l10n.backToPlantsAction),
        ),
      ),
    );
  }
}
