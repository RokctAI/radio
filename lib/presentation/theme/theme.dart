import 'package:flutter/material.dart';
import 'package:single_radio/presentation/styles/app_style.dart';

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
