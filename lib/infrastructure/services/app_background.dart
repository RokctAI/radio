import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Sends the app to the background without killing it, so playback continues.
///
/// Replaces the discontinued back_button_behavior plugin. The Android side
/// lives in MainActivity.kt; iOS has no equivalent, since an app cannot
/// background itself there, so this is a no-op rather than the
/// MissingPluginException the old plugin raised.
class AppBackground {
  AppBackground._();

  static const _channel = MethodChannel('app.radio.fm/app_background');

  static Future<void> minimize() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('minimize');
    } on PlatformException catch (e) {
      debugPrint('Could not move the app to the background: ${e.message}');
    }
  }
}
