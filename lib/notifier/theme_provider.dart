import 'package:flutter/material.dart';
import '/utils/app_pref.dart';

import '../utils/app_style.dart';

class ThemeProvider extends ChangeNotifier {
  bool currentTheme = false;

  ThemeMode get themeMode {
    if (currentTheme) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  changeTheme(bool theme, String key) async {
    AppPref.sharedPref(key, theme);
    currentTheme = theme;
    notifyListeners();
  }

  initialize() async {
    currentTheme = await AppPref.loadSharedPref("darkMode", false);
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    primaryColor: Styles.textColorDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Styles.textColorDark,
      secondary: Styles.textColorDark,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.light().scaffoldBackgroundColor,
    primaryColor: Styles.primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Styles.primaryColor,
      secondary: Styles.primaryColor,
    ),
  );
}
