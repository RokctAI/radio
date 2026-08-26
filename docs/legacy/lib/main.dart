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


﻿// main.dart
import 'package:base_sdk/src/services/remote_config_service.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/application/theme/theme_provider.dart';
import 'package:radio_sdk/radio_sdk.dart';
import 'package:single_radio/infrastructure/repositories/constant_stations_source.dart';
import 'package:single_radio/presentation/routes/app_router.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:single_radio/utils/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // base_sdk ships neutral tokens; this injects the app's palette.
  applyAppBrandColors();

  try {
    // Frappe-native remote config: fetched once before the first frame and
    // fail-soft, so a missing Radio row on the tenant site simply leaves the
    // dart-define defaults in place. Replaces Firebase Remote Config, which
    // this app no longer carries.
    await RemoteConfigService.initialize(appType: 'Radio');

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize(Constant.oneSignalId);
    OneSignal.Notifications.addPermissionObserver((permission) {});

    // Installer convention: every composed SDK registers its repositories
    // against their facades here, before runApp.
    // Host adapter first: radio_sdk defaults to the tenant site, which this
    // app does not have yet, and its isRegistered guard respects ours.
    GetIt.instance.registerSingleton<StationsSourceFacade>(
      const ConstantStationsSource(),
    );
    RadioSdkDependencies.register(GetIt.instance);

    MobileAds.instance.initialize();

    await UnityAds.init(
      gameId: await AppPref.loadSharedPrefString(Constant.unityAppId),
      onComplete: () => debugPrint('Unity Ads initialization complete'),
      onFailed: (error, message) =>
          debugPrint('Unity Ads initialization failed: $error $message'),
    );

    FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: true);

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider).isDark;
    return MaterialApp.router(
      theme: isDark ? MyThemes.darkTheme : MyThemes.lightTheme,
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final _appRouter = AppRouter();

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('An error occurred: $error'),
        ),
      ),
    );
  }
}
