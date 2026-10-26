import 'package:flutter/material.dart';

/// Design tokens: the only place raw colours, sizes and durations live
/// (AGENTS.md section 5, "Design system"). Widgets read them through
/// `Theme.of(context)` or the [AppSpacing], [AppRadius] and [AppMotion]
/// constants, never as literals.
abstract final class AppPalette {
  // Brand: a deep leaf green, with a warm terracotta (pot) accent.
  static const Color leaf10 = Color(0xFF0B2117);
  static const Color leaf20 = Color(0xFF14382A);
  static const Color leaf30 = Color(0xFF1E5139);
  static const Color leaf40 = Color(0xFF2A6B4B);
  static const Color leaf80 = Color(0xFFA6D4B7);
  static const Color leaf90 = Color(0xFFC6EBD3);
  static const Color leaf95 = Color(0xFFE3F5E9);

  static const Color clay30 = Color(0xFF6E2F14);
  static const Color clay40 = Color(0xFF8F3F1D);
  static const Color clay80 = Color(0xFFFFB693);
  static const Color clay90 = Color(0xFFFFDBCC);

  static const Color neutral6 = Color(0xFF101411);
  static const Color neutral10 = Color(0xFF181D1A);
  static const Color neutral12 = Color(0xFF1C211E);
  static const Color neutral17 = Color(0xFF262B28);
  static const Color neutral22 = Color(0xFF313633);
  static const Color neutral30 = Color(0xFF424844);
  static const Color neutral60 = Color(0xFF8B938E);
  static const Color neutral80 = Color(0xFFC1C9C3);
  static const Color neutral90 = Color(0xFFDDE5DF);
  static const Color neutral92 = Color(0xFFE5ECE6);
  static const Color neutral94 = Color(0xFFEBF2EC);
  static const Color neutral96 = Color(0xFFF1F7F2);
  static const Color neutral98 = Color(0xFFF7FBF7);
  static const Color white = Color(0xFFFFFFFF);

  static const Color error40 = Color(0xFFB3261E);
  static const Color error80 = Color(0xFFF2B8B5);
  static const Color error90 = Color(0xFFF9DEDC);
  static const Color error20 = Color(0xFF601410);
  static const Color error30 = Color(0xFF8C1D18);
  static const Color error10 = Color(0xFF410E0B);
}

/// Colour schemes built from [AppPalette]. Text/background pairs are checked
/// for WCAG 4.5:1 contrast in `test/core/design/tokens_test.dart`.
abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.leaf40,
    onPrimary: AppPalette.white,
    primaryContainer: AppPalette.leaf90,
    onPrimaryContainer: AppPalette.leaf10,
    secondary: AppPalette.clay40,
    onSecondary: AppPalette.white,
    secondaryContainer: AppPalette.clay90,
    onSecondaryContainer: AppPalette.clay30,
    error: AppPalette.error40,
    onError: AppPalette.white,
    errorContainer: AppPalette.error90,
    onErrorContainer: AppPalette.error10,
    surface: AppPalette.neutral98,
    onSurface: AppPalette.neutral10,
    onSurfaceVariant: AppPalette.neutral30,
    surfaceContainerLowest: AppPalette.white,
    surfaceContainerLow: AppPalette.neutral96,
    surfaceContainer: AppPalette.neutral94,
    surfaceContainerHigh: AppPalette.neutral92,
    surfaceContainerHighest: AppPalette.neutral90,
    outline: AppPalette.neutral60,
    outlineVariant: AppPalette.neutral80,
    inverseSurface: AppPalette.neutral17,
    onInverseSurface: AppPalette.neutral94,
    inversePrimary: AppPalette.leaf80,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.leaf80,
    onPrimary: AppPalette.leaf20,
    primaryContainer: AppPalette.leaf30,
    onPrimaryContainer: AppPalette.leaf90,
    secondary: AppPalette.clay80,
    onSecondary: AppPalette.clay30,
    secondaryContainer: AppPalette.clay40,
    onSecondaryContainer: AppPalette.clay90,
    error: AppPalette.error80,
    onError: AppPalette.error20,
    errorContainer: AppPalette.error30,
    onErrorContainer: AppPalette.error90,
    surface: AppPalette.neutral6,
    onSurface: AppPalette.neutral90,
    onSurfaceVariant: AppPalette.neutral80,
    surfaceContainerLowest: AppPalette.neutral6,
    surfaceContainerLow: AppPalette.neutral10,
    surfaceContainer: AppPalette.neutral12,
    surfaceContainerHigh: AppPalette.neutral17,
    surfaceContainerHighest: AppPalette.neutral22,
    outline: AppPalette.neutral60,
    outlineVariant: AppPalette.neutral30,
    inverseSurface: AppPalette.neutral90,
    onInverseSurface: AppPalette.neutral17,
    inversePrimary: AppPalette.leaf40,
  );
}

/// 4 dp spacing scale.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal page gutter.
  static const double gutter = lg;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 28;
  static const double pill = 999;
}

/// Minimum touch target: 48 dp satisfies both Android (48 dp) and iOS (44 pt).
abstract final class AppSizes {
  static const double minTouchTarget = 48;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 48;
  static const double iconXl = 96;

  /// Upper bound for readable line length on tablets and landscape.
  static const double maxContentWidth = 600;
}

/// Motion durations. Use [resolve] so reduce-motion turns animations off.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 350);

  static const Curve standard = Curves.easeInOutCubicEmphasized;

  /// Returns [Duration.zero] when the platform asks to reduce motion
  /// (NFR Accessibility: respect reduce-motion).
  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
