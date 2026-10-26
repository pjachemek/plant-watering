import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/design/tokens.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  // NFR Accessibility: text contrast >= 4.5:1 for every text/background pair.
  for (final MapEntry(key: name, value: s) in {
    'light': AppColorSchemes.light,
    'dark': AppColorSchemes.dark,
  }.entries) {
    group('$name scheme contrast', () {
      final pairs = <String, (Color, Color)>{
        'onPrimary/primary': (s.onPrimary, s.primary),
        'onPrimaryContainer/primaryContainer': (
          s.onPrimaryContainer,
          s.primaryContainer,
        ),
        'onSecondary/secondary': (s.onSecondary, s.secondary),
        'onSecondaryContainer/secondaryContainer': (
          s.onSecondaryContainer,
          s.secondaryContainer,
        ),
        'onError/error': (s.onError, s.error),
        'onErrorContainer/errorContainer': (
          s.onErrorContainer,
          s.errorContainer,
        ),
        'onSurface/surface': (s.onSurface, s.surface),
        'onSurfaceVariant/surface': (s.onSurfaceVariant, s.surface),
        'onSurface/surfaceContainerHighest': (
          s.onSurface,
          s.surfaceContainerHighest,
        ),
        'onSurfaceVariant/surfaceContainerHighest': (
          s.onSurfaceVariant,
          s.surfaceContainerHighest,
        ),
        'onInverseSurface/inverseSurface': (
          s.onInverseSurface,
          s.inverseSurface,
        ),
        'primary/surface (text buttons, links)': (s.primary, s.surface),
        'error/surface (error text)': (s.error, s.surface),
      };
      for (final MapEntry(key: label, value: (fg, bg)) in pairs.entries) {
        test('$label >= 4.5:1', () {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
        });
      }
    });
  }

  test('touch target meets 48 dp (Android) and 44 pt (iOS)', () {
    expect(AppSizes.minTouchTarget, greaterThanOrEqualTo(48));
  });

  testWidgets('AppMotion.resolve honours reduce-motion', (tester) async {
    late Duration normal;
    late Duration reduced;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          normal = AppMotion.resolve(context, AppMotion.medium);
          return MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                reduced = AppMotion.resolve(context, AppMotion.medium);
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );

    expect(normal, AppMotion.medium);
    expect(reduced, Duration.zero);
  });
}
