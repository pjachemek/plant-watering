import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantnfc/core/design/tokens.dart';
import 'package:plantnfc/features/presets/data/preset_catalog_loader.dart';
import 'package:plantnfc/features/presets/domain/preset_search.dart';
import 'package:plantnfc/l10n/app_localizations.dart';

/// Developer screen for the M3 demo (debug builds only): search the bundled
/// presets and see how long each search takes on this phone (NFR
/// Performance, 100 ms). The add-plant flow (M4) replaces it.
class PresetSearchScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PresetSearchScreen> createState() => _PresetSearchScreenState();
}

class _PresetSearchScreenState extends ConsumerState<PresetSearchScreen> {
  List<PresetMatch> _results = const [];
  Duration? _took;
  bool _searched = false;

  void _search(PresetSearch search, String query) {
    final watch = Stopwatch()..start();
    final results = search.search(query);
    watch.stop();
    setState(() {
      _results = results;
      _took = watch.elapsed;
      _searched = query.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final search = ref.watch(presetSearchProvider).value;
    final took = _took;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.presetSearchTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextField(
              enabled: search != null,
              autofocus: true,
              onChanged: search == null ? null : (q) => _search(search, q),
              decoration: InputDecoration(
                labelText: l10n.presetSearchLabel,
                hintText: l10n.presetSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_searched && took != null)
              Text(
                l10n.presetSearchTiming(
                  _results.length,
                  (took.inMicroseconds / 1000).toStringAsFixed(1),
                ),
              ),
            if (_searched && _results.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(l10n.presetSearchNoResults),
              ),
            for (final match in _results)
              ListTile(
                title: Text(match.preset.commonName),
                subtitle: Text(
                  [
                    match.preset.latinName,
                    if (match.matchedName != match.preset.commonName &&
                        match.matchedName != match.preset.latinName)
                      l10n.presetSearchMatched(match.matchedName),
                    l10n.presetSearchCare(
                      match.preset.intervalSummerDays,
                      match.preset.intervalWinterDays,
                      match.preset.method.name,
                    ),
                  ].join('\n'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
