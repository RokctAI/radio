// Host-shell theme shim: pages import
// package:single_radio/presentation/theme/theme.dart; the real theme lives in
// base_sdk. Re-exported here so pages resolve unchanged once this app is
// composed and the installer replaces this file.
//
// This file is also where THE APP'S brand palette lives: the kernel ships
// neutral defaults only, and [applyAppBrandColors] (called from main() before
// runApp) injects this app's values via AppStyle.injectBrandColors.
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';

import 'package:single_radio/presentation/styles/app_style.dart';

export 'package:base_sdk/src/presentation/theme/app_style.dart';
export 'package:base_sdk/src/presentation/theme/map_themes.dart';

/// Injects this app's palette into the shared AppStyle tokens.
///
/// primary is deliberately left at the kernel default: this is a Juvo app and
/// shares the Juvo brand colour. Only the page surface differs -- the player
/// sits on near-black so blurred artwork reads behind it.
void applyAppBrandColors() {
  AppStyle.injectBrandColors(
    surfaceDark: Styles.radioBgDarkColor,
  );
}

/// Player-surface tokens with no kernel equivalent: translucent whites layered
/// over blurred artwork. Kept on pure black and white rather than AppStyle's
/// black (0xFF232B2F), so the existing appearance is preserved exactly.
abstract class RadioStyle {
  RadioStyle._();

  static const Color surfaceOverlay = Color(0x1AFFFFFF);
  static const Color surfaceOverlayAlt = Color(0x1FFFFFFF);
  static const Color strokeSubtle = Color(0x4DFFFFFF);
  static const Color trackInactive = Color(0x62FFFFFF);
  static const Color scrim = Color(0x73000000);
  static const Color inkMuted = Color(0x8A000000);

  static Color whiteAlpha(double opacity) =>
      const Color(0xFFFFFFFF).withValues(alpha: opacity);
  static Color blackAlpha(double opacity) =>
      const Color(0xFF000000).withValues(alpha: opacity);
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    primaryColor: Styles.textColorDark,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Styles.textColorDark,
      secondary: Styles.textColorDark,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.light().scaffoldBackgroundColor,
    primaryColor: Styles.primaryColor,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Styles.primaryColor,
      secondary: Styles.primaryColor,
    ),
  );
}
