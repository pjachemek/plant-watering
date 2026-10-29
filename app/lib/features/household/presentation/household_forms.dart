import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/core/design/widgets/message_view.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/domain/household.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// What to say for each [HouseholdFailure]; each says what to do next.
String householdFailureText(AppLocalizations l10n, HouseholdFailure f) =>
    switch (f) {
      HouseholdFailure.network => l10n.householdErrorNetwork,
      HouseholdFailure.invalidCode => l10n.householdErrorInvalidCode,
      HouseholdFailure.confirmationRequired ||
      HouseholdFailure.notFound ||
      HouseholdFailure.unknown => l10n.householdErrorUnknown,
    };

/// Shown on the home screen before the person has a household (FR-7).
class HouseholdSetupView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MessageView(
      icon: Icons.home_outlined,
      iconLabel: l10n.householdSetupTitle,
      title: l10n.householdSetupTitle,
      body: l10n.householdSetupBody,
      action: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.householdCreate),
            icon: const Icon(Icons.add_home_outlined),
            label: Text(l10n.householdCreateAction),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.householdJoin),
            icon: const Icon(Icons.group_add_outlined),
            label: Text(l10n.householdJoinAction),
          ),
        ],
      ),
    );
  }
}

/// Create a household, with the person as its first member (FR-7).
class CreateHouseholdScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CreateHouseholdScreen> createState() =>
      _CreateHouseholdScreenState();
}

class _CreateHouseholdScreenState extends ConsumerState<CreateHouseholdScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _you = TextEditingController();
  bool _busy = false;
  bool _checked = false;
  HouseholdFailure? _failure;

  @override
  void dispose() {
    _name.dispose();
    _you.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = cleanName(_name.text, max: 80);
    final you = cleanName(_you.text, max: 60);
    setState(() => _checked = true);
    if (name == null || you == null || _busy) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    final result = await ref
        .read(householdRepositoryProvider)
        .create(name: name, displayName: you);
    if (!mounted) return;
    switch (result) {
      case Success():
        context.go(AppRoutes.plants);
      case Failure(:final failure):
        setState(() {
          _busy = false;
          _failure = failure;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FormScaffold(
      title: l10n.householdCreateTitle,
      failure: _failure,
      busy: _busy,
      submitLabel: l10n.householdCreateSubmit,
      onSubmit: _submit,
      fields: [
        TextField(
          controller: _name,
          enabled: !_busy,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          maxLength: 80,
          decoration: InputDecoration(
            labelText: l10n.householdNameLabel,
            hintText: l10n.householdNameHint,
            errorText: _checked && cleanName(_name.text, max: 80) == null
                ? l10n.householdNameRequired
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
        _YourNameField(controller: _you, enabled: !_busy, checked: _checked),
      ],
    );
  }
}

/// Join a household with an invite code or link (FR-7). [code] is filled in
/// when the app was opened from an invite link.
class JoinHouseholdScreen extends ConsumerStatefulWidget {
  const new({this.code, super.key});

  final String? code;

  @override
  ConsumerState<JoinHouseholdScreen> createState() =>
      _JoinHouseholdScreenState();
}

class _JoinHouseholdScreenState extends ConsumerState<JoinHouseholdScreen> {
  late final TextEditingController _code = TextEditingController(
    text: widget.code ?? '',
  );
  final TextEditingController _you = TextEditingController();
  bool _busy = false;
  bool _checked = false;
  HouseholdFailure? _failure;

  @override
  void dispose() {
    _code.dispose();
    _you.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = parseInviteCode(_code.text);
    final you = cleanName(_you.text, max: 60);
    setState(() => _checked = true);
    if (code == null || you == null || _busy) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    final result = await ref
        .read(householdRepositoryProvider)
        .join(code: code, displayName: you);
    if (!mounted) return;
    switch (result) {
      case Success():
        context.go(AppRoutes.plants);
      case Failure(:final failure):
        setState(() {
          _busy = false;
          _failure = failure;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FormScaffold(
      title: l10n.householdJoinTitle,
      failure: _failure,
      busy: _busy,
      submitLabel: l10n.householdJoinSubmit,
      onSubmit: _submit,
      fields: [
        TextField(
          controller: _code,
          enabled: !_busy,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.householdCodeLabel,
            helperText: l10n.householdCodeHelper,
            errorText: _checked && parseInviteCode(_code.text) == null
                ? l10n.householdCodeInvalidFormat
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
        _YourNameField(controller: _you, enabled: !_busy, checked: _checked),
      ],
    );
  }
}

class _YourNameField extends StatelessWidget {
  const new({
    required this.controller,
    required this.enabled,
    required this.checked,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      enabled: enabled,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.givenName],
      maxLength: 60,
      decoration: InputDecoration(
        labelText: l10n.householdYourNameLabel,
        helperText: l10n.householdYourNameHelper,
        errorText: checked && cleanName(controller.text, max: 60) == null
            ? l10n.householdYourNameRequired
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// A form screen: fields, a failure message, and one submit button.
class _FormScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.fields,
    required this.failure,
    required this.busy,
    required this.submitLabel,
    required this.onSubmit,
  });

  final String title;
  final List<Widget> fields;
  final HouseholdFailure? failure;
  final bool busy;
  final String submitLabel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = this.failure;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final field in fields) ...[
                    field,
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (failure != null) ...[
                    ErrorNote(text: householdFailureText(l10n, failure)),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  FilledButton(
                    onPressed: busy ? null : onSubmit,
                    child: busy
                        ? const SizedBox.square(
                            dimension: AppSizes.iconSm,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(submitLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An error with an icon (never colour alone), announced when it appears.
class ErrorNote extends StatelessWidget {
  const new({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, color: colors.onErrorContainer),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
