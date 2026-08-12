import 'package:flutter/material.dart';
import 'package:single_radio/presentation/styles/app_style.dart';

export 'package:single_radio/presentation/theme/app_style.dart';

/// Host-shell theme entry point: pages import this file, never app_style.dart
/// directly, so swapping in base_sdk's re-export shim later is a one-file
/// change.
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
