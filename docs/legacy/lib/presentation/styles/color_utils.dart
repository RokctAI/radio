// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


﻿import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:single_radio/presentation/styles/app_style.dart';

class ColorUtils {
  /// MaterialApp already selects its ThemeData from ThemeState, so the
  /// active brightness is the same answer without reaching for the state
  /// container from a static helper.
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static bool getMode(BuildContext context) => _isDark(context);

  static Color getBackGround(BuildContext context) {
    return _isDark(context)
        ? Styles.textColorDark
        : Styles.primaryColor;
  }
  static Color getRadioBackGround(BuildContext context) {
    return _isDark(context)
        ? Styles.radioBgDarkColor
        : Styles.primaryColor;
  }
  static Color getRadioStatus(BuildContext context) {
    return _isDark(context)
        ? Styles.textColorDark
        : Styles.radioFragTopBottomLightColor;
  }
  static Color getRadioFragTopBottomColor(BuildContext context) {
    return _isDark(context)
        ? Styles.textColorDark
        : Styles.radioFragTopBottomLightColor;
  }
  static Color getPrimaryText(BuildContext context) {
    return _isDark(context)
        ? Styles.primaryColor
        : Styles.textColorDark;
  }

  static Color getSecondText(BuildContext context) {
    return _isDark(context)
        ? Styles.textColorDarkLight
        : Styles.textColorLight;
  }

  static Color getTrackColor(BuildContext context) {
    return _isDark(context)
        ? Styles.trackTintDark
        : Styles.trackTint;
  }

  static Color getThumbColor(BuildContext context) {
    return _isDark(context)
        ? Styles.thumbTintDark
        : Styles.thumbTint;
  }

  static Color getTrackColorActive(BuildContext context) {
    return _isDark(context)
        ? Styles.trackTintActiveDark
        : Styles.trackTintActive;
  }

  static Color getThumbColorActive(BuildContext context) {
    return _isDark(context)
        ? Styles.thumbTintActiveDark
        : Styles.thumbTintActive;
  }

  static Color getLineColor(BuildContext context) {
    return _isDark(context)
        ? Styles.lineColorDark
        : Styles.lineColor;
  }

  static Color getBottomLineColor(BuildContext context) {
    return _isDark(context)
        ? Styles.bottomLineColorDark
        : Styles.bottomLineColor;
  }

  static Color getBlackWhite(BuildContext context) {
    return _isDark(context)
        ? AppStyle.white
        : AppStyle.black;
  }

  static Color getBlackWhiteReverse(BuildContext context) {
    return _isDark(context)
        ? AppStyle.black
        : AppStyle.white;
  }

  static Color getSplashName(BuildContext context) {
    return _isDark(context)
        ? AppStyle.white
        : Styles.splashNameBlue;
  }

  static Color getShimmerBase(BuildContext context) {
    return _isDark(context)
        ? Styles.shimmerBaseDark
        : Styles.shimmerBaseLight;
  }

  static Color getShimmerHigh(BuildContext context) {
    return _isDark(context)
        ? Styles.shimmerHighDark
        : Styles.shimmerHighLight;
  }
}
