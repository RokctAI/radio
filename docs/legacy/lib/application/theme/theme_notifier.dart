import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/theme/theme_state.dart';
import 'package:single_radio/utils/app_pref.dart';

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  static const _darkModeKey = 'darkMode';

  Future<void> initialize() async {
    state = state.copyWith(
      isDark: await AppPref.loadSharedPref(_darkModeKey, false),
    );
  }

  Future<void> changeTheme(bool isDark, {String key = _darkModeKey}) async {
    await AppPref.sharedPref(key, isDark);
    state = state.copyWith(isDark: isDark);
  }
}
