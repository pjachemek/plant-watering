import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/domain/household.dart';
import 'package:plantnfc/features/household/presentation/household_forms.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// The household: who is in it, invite someone, leave (FR-7).
class HouseholdScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  bool _busy = false;
  HouseholdFailure? _failure;

  Future<void> _invite(HouseholdSummary household) async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    final result = await ref
        .read(householdRepositoryProvider)
        .invite(household.id);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Success(:final value):
        await showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (_) => _InviteSheet(invite: value),
        );
      case Failure(:final failure):
        setState(() => _failure = failure);
    }
  }

  Future<void> _leave(HouseholdSummary household) async {
    final l10n = AppLocalizations.of(context);
    final leave = await _confirm(
      title: l10n.householdLeaveTitle(household.name),
      body: l10n.householdLeaveBody,
      action: l10n.householdLeaveConfirm,
    );
    if (!leave || !mounted) return;
    var result = await _leaveOnce(household, confirmDelete: false);
    if (result case Failure(failure: HouseholdFailure.confirmationRequired)) {
      if (!mounted) return;
      final delete = await _confirm(
        title: l10n.householdLastMemberTitle,
        body: l10n.householdLastMemberBody,
        action: l10n.householdDeleteConfirm,
      );
      if (!delete || !mounted) return;
      result = await _leaveOnce(household, confirmDelete: true);
    }
    if (!mounted) return;
    switch (result) {
      case Success():
        context.go(AppRoutes.plants);
      case Failure(:final failure):
        setState(() => _failure = failure);
    }
  }

  Future<Result<void, HouseholdFailure>> _leaveOnce(
    HouseholdSummary household, {
    required bool confirmDelete,
  }) async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    final result = await ref
        .read(householdRepositoryProvider)
        .leave(household.id, confirmDelete: confirmDelete);
    if (mounted) setState(() => _busy = false);
    return result;
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
  }) async {
    final l10n = AppLocalizations.of(context);
    final answer = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );
    return answer ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final household = ref.watch(currentHouseholdProvider).value;
    final failure = _failure;
    if (household == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.householdTitle)),
        body: const HouseholdSetupView(),
      );
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(household.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.householdMembersHeading,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final member in household.members)
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(member.displayName),
              ),
            const SizedBox(height: AppSpacing.lg),
            if (failure != null) ...[
              ErrorNote(text: householdFailureText(l10n, failure)),
              const SizedBox(height: AppSpacing.lg),
            ],
            FilledButton.icon(
              onPressed: _busy ? null : () => _invite(household),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.householdInviteAction),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: _busy ? null : () => _leave(household),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              icon: const Icon(Icons.logout),
              label: Text(l10n.householdLeaveAction),
            ),
          ],
        ),
      ),
    );
  }
}

/// The new invite: the code to read out, and its link to copy.
class _InviteSheet extends StatelessWidget {
  const new({required this.invite});

  final InviteCode invite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.householdInviteTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.householdInviteBody(invite.expiresAt.toLocal())),
            const SizedBox(height: AppSpacing.xl),
            Semantics(
              // Spaced, so a screen reader spells the code out.
              label: l10n.householdInviteCodeLabel(
                invite.code.split('').join(' '),
              ),
              excludeSemantics: true,
              child: SelectableText(
                invite.code,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(
                  ClipboardData(text: invite.link.toString()),
                );
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(l10n.householdLinkCopied)),
                  );
              },
              icon: const Icon(Icons.copy),
              label: Text(l10n.householdCopyLinkAction),
            ),
          ],
        ),
      ),
    );
  }
}
