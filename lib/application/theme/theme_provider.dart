import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/theme/theme_notifier.dart';
import 'package:single_radio/application/theme/theme_state.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier()..initialize(),
);
