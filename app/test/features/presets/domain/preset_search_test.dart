import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/presets/domain/preset.dart';
import 'package:plantnfc/features/presets/domain/preset_search.dart';

Preset preset(
  String id,
  String common,
  String latin, [
  List<(String, String)> aliases = const [],
]) => Preset(
  id: id,
  commonName: common,
  latinName: latin,
  aliases: [
    for (final (name, lang) in aliases) PresetAlias(name: name, lang: lang),
  ],
  intervalSummerDays: 7,
  intervalWinterDays: 14,
  method: WateringMethod.top,
  amount: WateringAmount.medium,
  amountHint: 'Until it drains',
  soilCheck: 'Top 2 cm dry',
  light: 'Bright, indirect',
  tips: const [],
  petToxic: PetToxicity.unknown,
  sources: const [],
);

final List<Preset> presets = [
  preset('monstera', 'Monstera', 'Monstera deliciosa', [
    ('Swiss cheese plant', 'en'),
    ('Monstera dziurawa', 'pl'),
  ]),
  preset('monstera-adansonii', 'Swiss cheese vine', 'Monstera adansonii', [
    ('Monstera Adansona', 'pl'),
  ]),
  preset('peace-lily', 'Peace lily', 'Spathiphyllum wallisii', [
    ('Skrzydłokwiat', 'pl'),
  ]),
  preset('snake-plant', 'Snake plant', 'Dracaena trifasciata', [
    ('Sansevieria', 'en'),
    ('Wężownica', 'pl'),
  ]),
  preset('zz-plant', 'ZZ plant', 'Zamioculcas zamiifolia', [
    ('Zamiokulkas', 'pl'),
  ]),
  preset('jade-plant', 'Jade plant', 'Crassula ovata', [
    ('Grubosz jajowaty', 'pl'),
  ]),
];

void main() {
  final search = PresetSearch(presets);
  List<String> ids(String query) =>
      search.search(query).map((m) => m.preset.id).toList();

  group('normalizeName', () {
    test('removes accents, case and punctuation', () {
      expect(
        normalizeName('  Skrzydłokwiat  Wallisa '),
        'skrzydlokwiat wallisa',
      );
      expect(normalizeName('Wężownica'), 'wezownica');
      expect(
        normalizeName('Schlumbergera × buckleyi'),
        'schlumbergera buckleyi',
      );
      expect(
        normalizeName("Nephrolepis 'Bostoniensis'"),
        'nephrolepis bostoniensis',
      );
      expect(normalizeName('Épée Ñandú'), 'epee nandu');
    });
  });

  group('search', () {
    test('finds nothing for an empty query', () {
      expect(search.search('   '), isEmpty);
    });

    test('ranks an exact name first, then names that start with it', () {
      expect(ids('monstera').first, 'monstera');
      expect(ids('mon'), ['monstera', 'monstera-adansonii']);
    });

    test('matches Latin names and aliases, in English and Polish', () {
      expect(ids('crassula'), ['jade-plant']);
      expect(ids('sansevieria'), ['snake-plant']);
      expect(ids('skrzyd'), ['peace-lily']);
      expect(ids('zamiokulkas'), ['zz-plant']);
    });

    test('ignores accents and case in the query', () {
      expect(ids('WEZOWNICA'), ['snake-plant']);
      expect(ids('wężow'), ['snake-plant']);
    });

    test('matches words in any order and by their beginnings', () {
      expect(ids('cheese vine').first, 'monstera-adansonii');
      expect(ids('plant snake'), ['snake-plant']);
      expect(
        ids('swiss ch'),
        containsAllInOrder(['monstera', 'monstera-adansonii']),
      );
    });

    test('tolerates typos: one in medium words, two in long ones', () {
      expect(ids('monstrea').first, 'monstera');
      expect(ids('sansevera'), ['snake-plant']);
      expect(ids('skrzydlokwait'), ['peace-lily']);
      expect(ids('zamioculcass'), ['zz-plant']);
    });

    test('does not stretch short words into anything', () {
      expect(ids('xyz'), isEmpty);
      expect(ids('qqqqqqqq'), isEmpty);
    });

    test('says which name matched', () {
      final match = search.search('skrzyd').single;
      expect(match.matchedName, 'Skrzydłokwiat');
      expect(match.preset.commonName, 'Peace lily');
    });

    test('keeps one result per preset and honours the limit', () {
      final results = search.search('m', limit: 1);
      expect(results, hasLength(1));
      final all = search.search('monstera');
      expect(all.map((m) => m.preset.id).toSet(), hasLength(all.length));
    });
  });

  group('typo allowance', () {
    test('none for short words, one for medium, two for long', () {
      expect(allowedTypos(3), 0);
      expect(allowedTypos(4), 1);
      expect(allowedTypos(6), 1);
      expect(allowedTypos(7), 2);
    });

    test('measures edits against the best beginning of the name', () {
      expect(prefixDistance('monste', 'monstera', 2), 0); // a true prefix
      expect(prefixDistance('monstr', 'monstera', 2), 1); // the e is missing
      expect(prefixDistance('mosntera', 'monstera', 2), 2);
      expect(prefixDistance('xxxxxxxx', 'monstera', 2), 3); // stops at limit+1
    });
  });

  test('searches 150 presets well under 100 ms (NFR Performance)', () {
    // The v1 target size (AGENTS.md section 8), from the sample above.
    final many = [
      for (var i = 0; i < 25; i++)
        for (final p in presets)
          preset('${p.id}-$i', '${p.commonName} $i', p.latinName, [
            for (final a in p.aliases) ('${a.name} $i', a.lang),
          ]),
    ];
    final big = PresetSearch(many);
    final queries = [
      'm',
      'monstrea',
      'skrzydlokwait',
      'zz',
      'swiss cheese',
      'xyz',
    ];
    final watch = Stopwatch();
    var slowest = Duration.zero;
    for (var round = 0; round < 20; round++) {
      for (final q in queries) {
        watch
          ..reset()
          ..start();
        big.search(q);
        watch.stop();
        if (watch.elapsed > slowest) slowest = watch.elapsed;
      }
    }
    expect(many, hasLength(150));
    expect(slowest, lessThan(const Duration(milliseconds: 100)));
  });
}
