import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

class NotFoundScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundTitle)),
      body: MessageView(
        icon: Icons.search_off,
        iconLabel: l10n.notFoundTitle,
        title: l10n.notFoundTitle,
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.plants),
          child: Text(l10n.backToPlantsAction),
        ),
      ),
    );
  }
}
