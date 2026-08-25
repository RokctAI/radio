import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(false) bool isDark,
  }) = _ThemeState;

  const ThemeState._();

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;
}
