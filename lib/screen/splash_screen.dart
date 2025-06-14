import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ads/open_ad_manager.dart';
import '../ads/InterstitialAd.dart';
import '../notifier/theme_provider.dart';

import '../utils/app_layout.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  Future<void> getAdsData() async {
    AdmobHelper admobHelper = AdmobHelper();
    admobHelper.initialization();
    appOpenAdManager.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();
    getAdsData().then((value){
      Future.delayed(const Duration(seconds: 2), () {
        if (AppOpenAdManager.isLoaded) {
          appOpenAdManager.showAdIfAvailable(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    });

    return Scaffold(
      body: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return Stack(
          children: [
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        );
      }),
    );
  }
}
