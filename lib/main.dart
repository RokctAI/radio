// main.dart
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:single_radio/di/radio_di.dart';
import 'package:single_radio/infrastructure/services/firebase_init.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:single_radio/infrastructure/services/remote_config.dart';
import 'package:single_radio/infrastructure/services/remote_config_provider.dart';
import 'package:single_radio/application/theme/theme_provider.dart';
import 'package:single_radio/presentation/pages/splash/splash_page.dart';
import 'package:single_radio/app_constants.dart';
import 'package:single_radio/utils/app_pref.dart';

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

    // Installer convention: every composed SDK registers its repositories
    // against their facades here, before runApp.
    RadioSdkDependencies.register(GetIt.instance);

    MobileAds.instance.initialize();

    await UnityAds.init(
      gameId: await AppPref.loadSharedPrefString(Constant.unityAppId),
      onComplete: () => debugPrint('Unity Ads initialization complete'),
      onFailed: (error, message) => debugPrint('Unity Ads initialization failed: $error $message'),
    );

    FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: true);

    runApp(
      ProviderScope(
        overrides: [
          remoteConfigProvider.overrideWithValue(remoteConfigService),
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider).isDark;
    return MaterialApp(
      theme: isDark ? MyThemes.darkTheme : MyThemes.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
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
