// Enforces coverage thresholds from AGENTS.md section 9:
// overall >= 70%, domain layer (lib/features/*/domain/) >= 90%.
// Generated code is excluded because it isn't written by hand.
//
// Usage: dart run tool/check_coverage.dart coverage/lcov.info
import 'dart:io';

const double overallMin = 70;
const double domainMin = 90;

final RegExp _generated = RegExp(
  r'(\.g\.dart|\.freezed\.dart|lib/l10n/app_localizations.*\.dart)$',
);
final RegExp _domain = RegExp('lib/features/[^/]+/domain/');

void main(List<String> args) {
  final path = args.isEmpty ? 'coverage/lcov.info' : args.first;
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Coverage file not found: $path');
    exit(2);
  }

  var totalFound = 0;
  var totalHit = 0;
  var domainFound = 0;
  var domainHit = 0;
  String? current;
  var found = 0;
  var hit = 0;

  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      current = line.substring(3).replaceAll(r'\', '/');
      found = 0;
      hit = 0;
    } else if (line.startsWith('LF:')) {
      found = int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      hit = int.parse(line.substring(3));
    } else if (line == 'end_of_record' && current != null) {
      if (!_generated.hasMatch(current)) {
        totalFound += found;
        totalHit += hit;
        if (_domain.hasMatch(current)) {
          domainFound += found;
          domainHit += hit;
        }
      }
      current = null;
    }
  }

  double pct(int h, int f) => f == 0 ? 100 : h * 100 / f;
  final overall = pct(totalHit, totalFound);
  final domain = pct(domainHit, domainFound);

  stdout
    ..writeln(
      'Overall: ${overall.toStringAsFixed(1)}% '
      '($totalHit/$totalFound lines, min $overallMin%)',
    )
    ..writeln(
      domainFound == 0
          ? 'Domain: no domain code yet (min $domainMin%)'
          : 'Domain: ${domain.toStringAsFixed(1)}% '
                '($domainHit/$domainFound lines, min $domainMin%)',
    );

  if (overall < overallMin || domain < domainMin) {
    stderr.writeln('Coverage below threshold.');
    exit(1);
  }
}
