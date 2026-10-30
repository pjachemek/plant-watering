import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:plantnfc/features/presets/domain/preset.dart';
import 'package:plantnfc/features/presets/domain/preset_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preset_catalog_loader.g.dart';

/// The bundled copy of presets/presets.json (ADR-0028).
const String presetAsset = 'assets/presets/presets.json';

/// Parses the presets file. CI validates it, so every entry should parse;
/// one that doesn't (an unknown method from a newer file format, say) is
/// skipped instead of failing the whole list (AGENTS.md section 5: tolerant
/// parsing).
PresetCatalog parsePresetCatalog(String json) {
  final data = jsonDecode(json) as Map<String, Object?>;
  final presets = <Preset>[];
  for (final item in data['presets']! as List<Object?>) {
    final preset = _preset(item);
    if (preset != null) presets.add(preset);
  }
  return PresetCatalog(version: data['version']! as int, presets: presets);
}

Preset? _preset(Object? item) {
  try {
    final p = item! as Map<String, Object?>;
    final amount = p['amount']! as Map<String, Object?>;
    T byName<T extends Enum>(List<T> values, Object? name) =>
        values.firstWhere((v) => v.name == name);
    return Preset(
      id: p['id']! as String,
      commonName: p['common_name']! as String,
      latinName: p['latin_name']! as String,
      aliases: [
        for (final a
            in (p['aliases']! as List<Object?>).cast<Map<String, Object?>>())
          PresetAlias(name: a['name']! as String, lang: a['lang']! as String),
      ],
      intervalSummerDays: p['interval_summer_days']! as int,
      intervalWinterDays: p['interval_winter_days']! as int,
      method: byName(WateringMethod.values, p['method']),
      amount: byName(WateringAmount.values, amount['size']),
      amountHint: amount['hint']! as String,
      soilCheck: p['soil_check']! as String,
      light: p['light']! as String,
      tips: (p['tips']! as List<Object?>).cast<String>(),
      petToxic: byName(PetToxicity.values, p['pet_toxic']),
      sources: [
        for (final s
            in (p['sources']! as List<Object?>).cast<Map<String, Object?>>())
          PresetSource(
            title: s['title']! as String,
            url: Uri.parse(s['url']! as String),
          ),
      ],
    );
  } on Object {
    return null;
  }
}

/// The bundled presets, loaded once.
@Riverpod(keepAlive: true)
Future<PresetCatalog> presetCatalog(Ref ref) async =>
    parsePresetCatalog(await rootBundle.loadString(presetAsset));

/// Search over the bundled presets, built once.
@Riverpod(keepAlive: true)
Future<PresetSearch> presetSearch(Ref ref) async =>
    PresetSearch((await ref.watch(presetCatalogProvider.future)).presets);
