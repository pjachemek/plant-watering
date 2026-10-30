import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/presets/data/preset_catalog_loader.dart';
import 'package:plantnfc/features/presets/domain/preset.dart';
import 'package:plantnfc/features/presets/domain/preset_search.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, Object?> entry(String id, {String method = 'top'}) => {
    'id': id,
    'common_name': 'Plant $id',
    'latin_name': 'Planta $id',
    'aliases': [
      {'name': 'Roślina $id', 'lang': 'pl'},
    ],
    'interval_summer_days': 7,
    'interval_winter_days': 14,
    'method': method,
    'amount': {'size': 'medium', 'hint': 'Until it drains'},
    'soil_check': 'Top 2 cm dry',
    'light': 'Bright, indirect',
    'tips': ['Water less in winter.'],
    'pet_toxic': 'no',
    'sources': [
      {'title': 'Example', 'url': 'https://example.org/$id'},
    ],
  };

  test('parses every field', () {
    final catalog = parsePresetCatalog(
      jsonEncode({
        'version': 3,
        'presets': [entry('a')],
      }),
    );

    expect(catalog.version, 3);
    final p = catalog.presets.single;
    expect(p.id, 'a');
    expect(p.aliases.single.lang, 'pl');
    expect(p.method, WateringMethod.top);
    expect(p.amount, WateringAmount.medium);
    expect(p.petToxic, PetToxicity.no);
    expect(p.sources.single.url.host, 'example.org');
  });

  test('skips an entry it cannot read instead of failing', () {
    final catalog = parsePresetCatalog(
      jsonEncode({
        'version': 1,
        'presets': [
          entry('a'),
          entry('b', method: 'drip-irrigation'),
          {'id': 'c'},
        ],
      }),
    );

    expect(catalog.presets.map((p) => p.id), ['a']);
  });

  test('the bundled presets all load and are searchable', () async {
    final json = await rootBundle.loadString(presetAsset);
    final raw = (jsonDecode(json) as Map<String, Object?>)['presets']! as List;

    final catalog = parsePresetCatalog(json);

    expect(catalog.presets, hasLength(raw.length));
    final search = PresetSearch(catalog.presets);
    for (final preset in catalog.presets) {
      // Every preset is found by its own names.
      for (final name in preset.names) {
        expect(
          search.search(name).map((m) => m.preset.id),
          contains(preset.id),
          reason: name,
        );
      }
    }
  });

  group('searching the bundled presets', () {
    late PresetSearch search;

    setUpAll(() async {
      final catalog = parsePresetCatalog(
        await rootBundle.loadString(presetAsset),
      );
      search = PresetSearch(catalog.presets);
    });

    String? first(String query) => search.search(query).firstOrNull?.preset.id;

    test('finds what people type, in English, Polish and Latin', () {
      final expected = {
        'monstera': 'monstera',
        'swiss cheese vine': 'monstera-adansonii',
        'skrzydlokwiat': 'peace-lily',
        'zamiokulkas': 'zz-plant',
        'sansevieria': 'snake-plant',
        'grudnik': 'christmas-cactus',
        'fiolek afrykanski': 'african-violet',
        'phalaenopsis': 'moth-orchid',
        'strelitzia nicolai': 'strelitzia-nicolai',
        'bird of paradise': 'bird-of-paradise',
        'ficus lyrata': 'fiddle-leaf-fig',
      };
      for (final MapEntry(key: query, value: id) in expected.entries) {
        expect(first(query), id, reason: query);
      }
    });

    test('forgives typos', () {
      expect(first('diffenbachia'), 'dieffenbachia');
      expect(first('zamioculcus'), 'zz-plant');
      expect(first('calatea'), 'calathea');
      expect(first('strelicja krolewska'), 'bird-of-paradise');
    });

    test('lists every match for a shared word', () {
      final figs = search.search('figowiec').map((m) => m.preset.id);
      expect(
        figs,
        containsAll(['fiddle-leaf-fig', 'rubber-plant', 'weeping-fig']),
      );
    });

    test('answers within 100 ms (NFR Performance)', () {
      final watch = Stopwatch()..start();
      ['m', 'skrzyd', 'diffenbachia', 'palm', 'xyzzy'].forEach(search.search);
      watch.stop();
      expect(watch.elapsedMilliseconds, lessThan(100));
    });
  });
}
