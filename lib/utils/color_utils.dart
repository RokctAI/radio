import 'package:flutter/material.dart';
import '/utils/app_style.dart';
import '/notifier/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorUtils {
  static bool getMode(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? true
        : false;
  }

  static Color getBackGround(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.textColorDark
        : Styles.primaryColor;
  }
  static Color getRadioBackGround(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.radioBgDarkColor
        : Styles.primaryColor;
  }
  static Color getRadioStatus(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.textColorDark
        : Styles.radioFragTopBottomLightColor;
  }
  static Color getRadioFragTopBottomColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.textColorDark
        : Styles.radioFragTopBottomLightColor;
  }
  static Color getPrimaryText(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.primaryColor
        : Styles.textColorDark;
  }

  static Color getSecondText(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.textColorDarkLight
        : Styles.textColorLight;
  }

  static Color getTrackColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.trackTintDark
        : Styles.trackTint;
  }

  static Color getThumbColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.thumbTintDark
        : Styles.thumbTint;
  }

  static Color getTrackColorActive(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.trackTintActiveDark
        : Styles.trackTintActive;
  }

  static Color getThumbColorActive(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.thumbTintActiveDark
        : Styles.thumbTintActive;
  }

  static Color getLineColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.lineColorDark
        : Styles.lineColor;
  }

  static Color getBottomLineColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.bottomLineColorDark
        : Styles.bottomLineColor;
  }

  static Color getBlackWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Colors.white
        : Colors.black;
  }

  static Color getBlackWhiteReverse(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Colors.black
        : Colors.white;
  }

  static Color getSplashName(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Colors.white
        : Styles.splashNameBlue;
  }

  static Color getShimmerBase(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.shimmerBaseDark
        : Styles.shimmerBaseLight;
  }

  static Color getShimmerHigh(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).currentTheme ==
            true
        ? Styles.shimmerHighDark
        : Styles.shimmerHighLight;
  }
}
