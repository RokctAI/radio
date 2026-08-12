// main.dart
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'utils/firebase_init.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'utils/remote_config.dart';
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

  late final RemoteConfigService remoteConfigService;

  try {
    await initializeFirebase();
    debugPrint('Firebase initialized successfully in main()');

    // Initialize Remote Config
    remoteConfigService = RemoteConfigService();
    await remoteConfigService.initialize();
   // await RemoteConfigService().fetch();
    // Fetch and activate remote config
    try {
      await remoteConfigService.fetch();
      bool activated = await remoteConfigService.activate();

      if (activated) {
        debugPrint('Remote config activated successfully');
        debugPrint('App name from remote config: ${remoteConfigService.appName}');
      } else {
        debugPrint('Failed to activate remote config in main.dart ${remoteConfigService.appName}');
      }
    } catch (e) {
      debugPrint('Error with Remote Config: $e');
      // Continue with default values
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize(remoteConfigService.oneSignalId);
    OneSignal.Notifications.addPermissionObserver((permission) {});

    MobileAds.instance.initialize();

    await UnityAds.init(
      gameId: await AppPref.loadSharedPrefString(Constant.UNITY_APP_APP_ID),
      onComplete: () => debugPrint('Unity Ads initialization complete'),
      onFailed: (error, message) => debugPrint('Unity Ads initialization failed: $error $message'),
    );

    FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: true);

    late final radiomodel = RadioNotifier();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()..initialize()),
          ChangeNotifierProvider(create: (context) => ImageUrlNotifier()),
          ChangeNotifierProvider(create: (context) => AdsCallBack()),
          ChangeNotifierProvider<RadioNotifier>.value(value: radiomodel),
          ChangeNotifierProvider(create: (context) => TimerNotifier(onTimer: radiomodel.pause)),
          Provider<RemoteConfigService>.value(value: remoteConfigService),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    // Handle the error, perhaps by showing an error screen
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        theme: themeProvider.currentTheme ? MyThemes.darkTheme : MyThemes.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

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