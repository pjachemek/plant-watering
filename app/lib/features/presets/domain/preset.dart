import 'package:meta/meta.dart';

/// How a plant is watered (AGENTS.md section 8).
enum WateringMethod { top, bottom, soak, mist }

enum WateringAmount { small, medium, large }

enum PetToxicity { yes, no, unknown }

/// Another name a preset is known by, in English or Polish.
@immutable
class PresetAlias {
  const new({required this.name, required this.lang});

  final String name;

  /// `en` or `pl`.
  final String lang;
}

@immutable
class PresetSource {
  const new({required this.title, required this.url});

  final String title;
  final Uri url;
}

/// A curated care preset (presets/presets.json, ADR-0028). Its values are
/// copied to a new plant as defaults, which the person can override.
@immutable
class Preset {
  const new({
    required this.id,
    required this.commonName,
    required this.latinName,
    required this.aliases,
    required this.intervalSummerDays,
    required this.intervalWinterDays,
    required this.method,
    required this.amount,
    required this.amountHint,
    required this.soilCheck,
    required this.light,
    required this.tips,
    required this.petToxic,
    required this.sources,
  });

  /// Stable slug, stored on plants as `preset_id`.
  final String id;
  final String commonName;
  final String latinName;
  final List<PresetAlias> aliases;
  final int intervalSummerDays;
  final int intervalWinterDays;
  final WateringMethod method;
  final WateringAmount amount;
  final String amountHint;
  final String soilCheck;
  final String light;
  final List<String> tips;
  final PetToxicity petToxic;
  final List<PresetSource> sources;

  /// Every name search should find it by.
  Iterable<String> get names => [
    commonName,
    latinName,
    for (final alias in aliases) alias.name,
  ];
}

/// The bundled presets and their version. Plants keep the version they were
/// created from, so an update never silently changes them.
@immutable
class PresetCatalog {
  const new({required this.version, required this.presets});

  final int version;
  final List<Preset> presets;
}
