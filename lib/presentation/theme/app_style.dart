import 'package:flutter/material.dart';
import 'package:single_radio/presentation/styles/app_style.dart';

/// The app's colour tokens. Pages use these; raw `Colors.*` is forbidden.
///
/// Names follow base_sdk's AppStyle where they overlap (white, black,
/// transparent, textGrey, primary), so replacing this with the SDK-installed
/// re-export shim later is a swap rather than a rewrite. The player-surface
/// tokens below are this app's own: translucent whites layered over blurred
/// artwork, which the kernel has no equivalent for.
abstract class AppStyle {
  AppStyle._();

  static Color get primary => Styles.primaryColor;

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color textGrey = Color(0xFF9E9E9E);

  /// Chrome layered over the blurred artwork background.
  static const Color surfaceOverlay = Color(0x1AFFFFFF);
  static const Color surfaceOverlayAlt = Color(0x1FFFFFFF);
  static const Color strokeSubtle = Color(0x4DFFFFFF);
  static const Color trackInactive = Color(0x62FFFFFF);

  /// Ink on light chrome.
  static const Color scrim = Color(0x73000000);
  static const Color inkMuted = Color(0x8A000000);

  static Color whiteAlpha(double opacity) => white.withValues(alpha: opacity);
  static Color blackAlpha(double opacity) => black.withValues(alpha: opacity);
}
