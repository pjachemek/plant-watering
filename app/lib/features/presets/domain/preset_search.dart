import 'dart:math';

import 'package:meta/meta.dart';
import 'package:plantnfc/features/presets/domain/preset.dart';

/// Letters with accents and their plain form: Polish, plus the common
/// Western European ones that appear in plant names. Dart has no built-in
/// Unicode normalisation, and this covers every name in the presets.
const Map<String, String> _plain = {
  'ą': 'a',
  'ć': 'c',
  'ę': 'e',
  'ł': 'l',
  'ń': 'n',
  'ó': 'o',
  'ś': 's',
  'ź': 'z',
  'ż': 'z',
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'ã': 'a',
  'å': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'ò': 'o',
  'ô': 'o',
  'ö': 'o',
  'õ': 'o',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'ñ': 'n',
  'ç': 'c',
  'æ': 'ae',
  'œ': 'oe',
  'ß': 'ss',
  '×': ' ',
};

final RegExp _separators = RegExp('[^a-z0-9]+');

/// Lower case, accents removed, anything but letters and digits a single
/// space: "Skrzydłokwiat Wallisa" → "skrzydlokwiat wallisa". Matches how
/// presets/validate.mjs compares names.
String normalizeName(String text) {
  final lower = text.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_plain[char] ?? char);
  }
  return buffer.toString().replaceAll(_separators, ' ').trim();
}

/// How many typos a word of [length] may have (AGENTS.md section 8: edit
/// distance 1–2): none for short words, where a typo makes another word.
int allowedTypos(int length) => length >= 7
    ? 2
    : length >= 4
    ? 1
    : 0;

/// One search result: the preset and the name that matched best.
@immutable
class PresetMatch {
  const new({
    required this.preset,
    required this.matchedName,
    required this.score,
  });

  final Preset preset;

  /// Shown when it isn't the common name ("matched Skrzydłokwiat").
  final String matchedName;
  final int score;
}

/// Offline, typo-tolerant search over every name of every preset (FR-3).
/// The index is built once; each search is a scan of a few hundred short
/// names, well under the 100 ms target (NFR Performance, ADR-0029).
class PresetSearch {
  new(List<Preset> presets)
    : _entries = [
        for (final preset in presets)
          for (final name in preset.names)
            _Entry(preset, name, normalizeName(name)),
      ];

  final List<_Entry> _entries;

  /// Best matches for [query], best first, at most [limit]. An empty query
  /// finds nothing: the screen shows the full list instead.
  List<PresetMatch> search(String query, {int limit = 20}) {
    final q = normalizeName(query);
    if (q.isEmpty) return const [];
    final words = q.split(' ');
    final best = <String, PresetMatch>{};
    for (final entry in _entries) {
      final score = _score(q, words, entry);
      if (score == 0) continue;
      final current = best[entry.preset.id];
      if (current == null || score > current.score) {
        best[entry.preset.id] = PresetMatch(
          preset: entry.preset,
          matchedName: entry.name,
          score: score,
        );
      }
    }
    final results = best.values.toList()
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        return byScore != 0
            ? byScore
            : a.preset.commonName.compareTo(b.preset.commonName);
      });
    return results.take(limit).toList();
  }

  static int _score(String q, List<String> words, _Entry entry) {
    final name = entry.normalized;
    if (name == q) return 100;
    if (name.startsWith(q)) return 90;
    // Every word of the query starts a word of the name, in any order.
    if (words.every((w) => entry.words.any((n) => n.startsWith(w)))) {
      return 80;
    }
    // Typos: every query word is close to the start of some word.
    var typos = 0;
    for (final word in words) {
      final allowed = allowedTypos(word.length);
      final distance = entry.words
          .map((n) => prefixDistance(word, n, allowed))
          .reduce(min);
      if (distance > allowed) {
        typos = -1;
        break;
      }
      typos += distance;
    }
    if (typos >= 0) return 70 - 10 * typos;
    if (q.length >= 3 && name.contains(q)) return 40;
    return 0;
  }
}

class _Entry {
  new(this.preset, this.name, this.normalized) : words = normalized.split(' ');

  final Preset preset;
  final String name;
  final String normalized;
  final List<String> words;
}

/// The fewest edits turning [word] into some beginning of [target], so a
/// half-typed, misspelled word still matches ("monstr" → "monstera"). Stops
/// early once the distance can only exceed [limit].
@visibleForTesting
int prefixDistance(String word, String target, int limit) {
  // Levenshtein against [target], keeping the best value over all prefixes
  // of [target] (the last row's minimum).
  var previous = List<int>.generate(target.length + 1, (i) => i);
  for (var i = 1; i <= word.length; i++) {
    final current = List<int>.filled(target.length + 1, 0)..[0] = i;
    var rowBest = current[0];
    for (var j = 1; j <= target.length; j++) {
      final cost = word.codeUnitAt(i - 1) == target.codeUnitAt(j - 1) ? 0 : 1;
      current[j] = min(
        min(current[j - 1] + 1, previous[j] + 1),
        previous[j - 1] + cost,
      );
      rowBest = min(rowBest, current[j]);
    }
    if (rowBest > limit) return limit + 1;
    previous = current;
  }
  return previous.reduce(min);
}
