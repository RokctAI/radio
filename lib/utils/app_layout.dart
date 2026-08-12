import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ColorUtils.dart';

class AppLayout {
  /// WidgetsBinding.window is deprecated and slated for removal ahead of
  /// multi-window support. The implicit view carries the same metrics.
  static Size getSize() {
    final FlutterView view =
        WidgetsBinding.instance.platformDispatcher.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  static getScreenHeight() {
    return getSize().height;
  }

  static getScreenWidth() {
    return getSize().width;
  }

  static getHeight(double pixels) {
    double x = getScreenHeight() / pixels;
    return getScreenHeight() / x;
  }

  static getWidth(double pixels) {
    double x = getScreenWidth() / pixels;
    return getScreenWidth() / x;
  }

  static screenPortrait() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    systemStatusColor(colors:Colors.transparent);
  }

  static screenPortrait1() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    systemStatusColor(colors:Colors.transparent);
  }

  static screenLandscape() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static screenStatus(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  static systemRadioStatusColor(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorUtils.getRadioStatus(context),
      systemNavigationBarColor:
      ColorUtils.getBackGround(context), // Set color here
    ));
  }

  static systemStatusColor({BuildContext? context, Color? colors}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colors??ColorUtils.getBackGround(context!),
      systemNavigationBarColor:colors??
      ColorUtils.getBackGround(context!), // Set color here
    ));
  }
}
