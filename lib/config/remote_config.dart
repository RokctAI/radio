import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'package:single_radio/config/constant.dart';


class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  late FirebaseRemoteConfig _remoteConfig;

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal() {
    _remoteConfig = FirebaseRemoteConfig.instance;
  }

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),  // Adjust this value as needed
        minimumFetchInterval: Duration.zero,  // This allows fetching each time
      ));
      if (kDebugMode) {
        print('Remote Config initialized successfully in remote_config.dart');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Remote Config: $e');
      }
    }
  }

 /* Future<void> fetch() async {
    try {
      await _remoteConfig.fetch();
      print('Remote Config fetched successfully');
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }
*/
  Future<bool> fetch() async {
    try {
      bool fetched = await _remoteConfig.activate();
      if (fetched) {
        _updateConstants();
        if (kDebugMode) {
          print('Remote Config fetch successfully');
        }
      } else {
        if (kDebugMode) {
          print('Remote Config fetch failed in remote_config.dart');
        }
      }
      return fetched;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Remote Config: $e');
      }
      return false;
    }
  }
  Future<bool> activate() async {
    try {
      bool activated = await _remoteConfig.activate();
      if (activated) {
        _updateConstants();
        if (kDebugMode) {
          print('Remote Config activated successfully');
        }
      } else {
        if (kDebugMode) {
          print('Remote Config activation failed in remote_config.dart');
        }
      }
      return activated;
    } catch (e) {
      if (kDebugMode) {
        print('Error activating Remote Config: $e');
      }
      return false;
    }
  }

  void _updateConstants() {
    Constant.appName = _remoteConfig.getString('appName');
    Constant.appMotto = _remoteConfig.getString('appMotto');
    Constant.minAppVersion = _remoteConfig.getString('minAppVersion');
    Constant.streamUrl = _remoteConfig.getString('streamUrl');
    Constant.twitterUrl = _remoteConfig.getString('twitterUrl');
    Constant.facebookUrl = _remoteConfig.getString('facebookUrl');
    Constant.whatsappUrl = _remoteConfig.getString('whatsappUrl');
    Constant.privacyUrl = _remoteConfig.getString('privacyUrl');
    Constant.aboutUsUrl = _remoteConfig.getString('aboutUsUrl');
    Constant.rateUsUrl = _remoteConfig.getString('rateUsUrl');
    Constant.showADS = _remoteConfig.getBool('showADS');
    Constant.oneSignalId = _remoteConfig.getString('oneSignalId');
    // Comma-separated, in priority order. Left at the built-in defaults when
    // the key is absent so a station only sets it if its titles need it.
    final separators = _remoteConfig.getString('titleSeparators');
    if (separators.isNotEmpty) {
      Constant.titleSeparators =
          separators.split(',').where((s) => s.isNotEmpty).toList();
    }
    Constant.deezerApiKey = _remoteConfig.getString('deezerApiKey');
  }

  // Getter methods for each config value
  String get appName => _remoteConfig.getString('appName');
  String get appMotto => _remoteConfig.getString('appMotto');
  String get minAppVersion => _remoteConfig.getString('minAppVersion');
  String get streamUrl => _remoteConfig.getString('streamUrl');
  String get twitterUrl => _remoteConfig.getString('twitterUrl');
  String get facebookUrl => _remoteConfig.getString('facebookUrl');
  String get whatsappUrl => _remoteConfig.getString('whatsappUrl');
  String get privacyUrl => _remoteConfig.getString('privacyUrl');
  String get aboutUsUrl => _remoteConfig.getString('aboutUsUrl');
  String get rateUsUrl => _remoteConfig.getString('rateUsUrl');
  bool get showADS => _remoteConfig.getBool('showADS');
  String get oneSignalId => _remoteConfig.getString('oneSignalId');
  String get titleSeparators => _remoteConfig.getString('titleSeparators');
  String get deezerApiKey => _remoteConfig.getString('deezerApiKey');
}
