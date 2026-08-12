import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:single_radio/infrastructure/services/open_ad_manager.dart';
import 'package:single_radio/infrastructure/services/interstitial_ad.dart';
import 'package:single_radio/app_constants.dart';
import 'package:single_radio/utils/app_layout.dart';
import 'package:single_radio/presentation/pages/home/home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:single_radio/presentation/pages/webview/webview_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();
    // Remove the native splash screen immediately
    FlutterNativeSplash.remove();
    _initialize();
  }

  Future<void> _initialize() async {
    if (kDebugMode) {
      print("Starting initialization");
    }
    await getAdsData();
    if (kDebugMode) {
      print("Ads data loaded");
    }
    await Future.delayed(const Duration(seconds: 2));
    if (kDebugMode) {
      print("Delay complete");
    }

    if (mounted) {
      if (kDebugMode) {
        print("Widget still mounted, checking version");
      }
      await checkVersion();
    } else {
      if (kDebugMode) {
        print("Widget no longer mounted");
      }
    }
  }

  Future<void> getAdsData() async {
    AdmobHelper admobHelper = AdmobHelper();
    admobHelper.initialization();
     appOpenAdManager.loadAd();
  }

  Future<void> checkVersion() async {
    if (kDebugMode) {
      print("Starting version check");
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      if (kDebugMode) {
        print("Current version: $currentVersion");
      }
      if (kDebugMode) {
        print("Minimum required version: ${Constant.minAppVersion}");
      }

      if (isVersionGreaterOrEqual(currentVersion, Constant.minAppVersion)) {
        if (kDebugMode) {
          print("Version is equal or greater, proceeding normally");
        }
        navigateToHome();
      } else {
        if (kDebugMode) {
          print("Version is less, opening WebView");
        }
        navigateToWebView();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during version check: $e");
      }
      if (kDebugMode) {
        print("Using default version and proceeding to home screen");
      }
      // Fallback to home screen in case of error
      navigateToHome();
    }
  }

  void navigateToHome() {
    if (!mounted) return;
    if (AppOpenAdManager.isLoaded) {
      appOpenAdManager.showAdIfAvailable(context);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void navigateToWebView() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(url: Constant.rateUsUrl)),
    );
  }

  bool isVersionGreaterOrEqual(String currentVersion, String minVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> min = minVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < min.length; i++) {
      if (i >= current.length) return false;
      if (current[i] > min[i]) return true;
      if (current[i] < min[i]) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();

    return Scaffold(
      body: Stack(
          children: [
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    'Powered by',  // Replace with your app name or desired text
                    style: TextStyle(
                      fontSize: 16,
                     // color: Color(0xFFFF6600),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Image.asset(
                    'assets/images/juvo.png',  // Replace with your image path
                    width: 50,  // Adjust size as needed
                    height: 50,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
