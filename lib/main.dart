import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'ads/ads_callback.dart';
import 'notifier/image_url_notifier.dart';
import 'notifier/radio_notifier.dart';
import 'notifier/theme_provider.dart';
import 'notifier/timer_notifier.dart';
import 'screen/splash_screen.dart';
import 'utils/Constant.dart';
import 'utils/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize(Constant.oneSignalId);
  OneSignal.Notifications.addPermissionObserver((permission) { });
  MobileAds.instance.initialize();
  await UnityAds.init(
    gameId: await AppPref.loadSharedPrefString(Constant.UNITY_APP_APP_ID),
    onComplete: () {},
    onFailed: (error, message) {},
  );
  FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: true);
  late final radiomodel = RadioNotifier();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()..initialize()),

        ChangeNotifierProvider(create: (context) => ImageUrlNotifier()),
        ChangeNotifierProvider(create: (context) => AdsCallBack()),
        ChangeNotifierProvider<RadioNotifier>.value(value: radiomodel),
        ChangeNotifierProvider(create: (context) => TimerNotifier(onTimer: radiomodel.pause)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        theme: themeProvider.currentTheme
            ? MyThemes.darkTheme
            : MyThemes.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
