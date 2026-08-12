import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:single_radio/config/constant.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static bool isLoaded = false;
  static String adsType = '';

  void loadAd() async {
    adsType = Constant.adsKey;
    if (adsType.contains("0")) {
      AppOpenAd.load(
        adUnitId: Platform.isIOS?Constant.openAdsIos:Constant.openAds,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            isLoaded = true;
          },
          onAdFailedToLoad: (error) {
            // Handle the error.
          },
        ),
      );
    }
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable(BuildContext context) {
    if (_appOpenAd == null) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
