import 'dart:io';

import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/Constant.dart';
import '../utils/app_style.dart';
import 'ads_callback.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart' as fb;

InterstitialAd? _interstitialAd;
String interCode = "";
String bannerCode = "";
String adsType = '';

class AdmobHelper {
  static bool isBannerLoaded = false;
  initialization() async {
    adsType = Constant.ADSKEY;

    if (adsType.contains("0")) {
      interCode = Platform.isIOS?Constant.INTER_ADS_IOS:Constant.INTER_ADS;
      bannerCode = Platform.isIOS?Constant.BANNER_ADS_IOS:Constant.BANNER_ADS;
      createInterad();
    } else if (adsType.contains("2")) {
      loadUnityIntAd();
    } else if (adsType.contains("1")) {
      interCode = Platform.isIOS?Constant.FBINTERS_ID_IOS:Constant.FBINTERS_ID;
      bannerCode = Platform.isIOS?Constant.FBBANNER_ID_IOS:Constant.FBBANNER_ID;
      loadfbInterstitialAd();
    }
  }

  // create interstitial ads
  void createInterad() {
    InterstitialAd.load(
      adUnitId: interCode,
      request: const AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
      }, onAdFailedToLoad: (LoadAdError error) {
        _interstitialAd = null;
      }),
    );
  }

  void showInterad(BuildContext context) {
    if (adsType.contains("0")) {
      if (_interstitialAd == null) {
        createInterad();
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint("ad onAdshowedFullscreen");
      }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint("ad Disposed");
        ad.dispose();
        createInterad();
        Provider.of<AdsCallBack>(context, listen: false).setDismiss();
      }, onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError aderror) {
        debugPrint('$ad OnAdFailed $aderror');
        ad.dispose();
        createInterad();
        Provider.of<AdsCallBack>(context, listen: false).setFailed();
      });
      _interstitialAd!.show();
    } else if (adsType.contains("2")) {
      showIntAd();
    } else if (adsType.contains("1")) {
      showFbInterstitialAd();
    }
  }

  static Future<void> loadUnityIntAd() async {
    await UnityAds.load(
      placementId: Platform.isIOS?Constant.UNITY_INTER_PLACEMENT_ID_IOS:Constant.UNITY_INTER_PLACEMENT_ID,
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
  }

  static Future<void> showIntAd() async {
    UnityAds.showVideoAd(
        placementId: Platform.isIOS?Constant.UNITY_INTER_PLACEMENT_ID_IOS:Constant.UNITY_INTER_PLACEMENT_ID,
        onStart: (placementId) => debugPrint('Video Ad $placementId started'),
        onClick: (placementId) => debugPrint('Video Ad $placementId click'),
        onSkipped: (placementId) => debugPrint('Video Ad $placementId skipped'),
        onComplete: (placementId) async {
          await loadUnityIntAd();
        },
        onFailed: (placementId, error, message) async {
          await loadUnityIntAd();
        });
  }

  bool _fbisInterstitialAdLoaded = false;
  Future loadfbInterstitialAd() async {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interCode,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _fbisInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _fbisInterstitialAdLoaded = false;
          loadfbInterstitialAd();
        }
      },
    );
  }

  showFbInterstitialAd() {
    if (_fbisInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    }
  }


  //Banner Ads section
  static Widget showUnityBannerAd(){
    return UnityBannerAd(
        placementId: Platform.isIOS?'Banner_Ios':"Banner_Android",
        onClick: (placementId) => debugPrint('Video Ad $placementId click'),
        onFailed: (placementId, error, message) async {
          await loadUnityBannerAd();
        },
        onLoad: (value) async{
          await loadUnityBannerAd();
          isBannerLoaded = true;
          debugPrint(value);
        }
    );
  }
  static Widget showFbBanner() {
    return FacebookBannerAd(
      placementId: bannerCode,
      bannerSize: fb.BannerSize.STANDARD,
      listener: (result, value) {
        debugPrint("Banner Ad: $result -->  $value");
      },
    );
  }
  static Future<void> loadUnityBannerAd() async {
    await UnityAds.load(
      placementId: Platform.isIOS?'Banner_Ios':'Banner_Android',
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
  }
  static BannerAd getBannerAd() {
    BannerAd bAd = BannerAd(
        // smartBanner is deprecated. banner is the fixed 320x50 slot, which
        // matches the 50px height showBanner already reserves.
        size: AdSize.banner,
        adUnitId: bannerCode,
        listener: BannerAdListener(
            onAdClosed: (Ad ad) {},
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdLoaded: (Ad ad) {
              isBannerLoaded = true;
            },
            onAdOpened: (Ad ad) {}),
        request: const AdRequest());
    bAd.load();
    return bAd;
  }
  static AdWidget buildAdWidget() {
    return AdWidget(ad: getBannerAd());
  }
  static Widget showBanner(BuildContext context){
    if(adsType.contains("0")){
      return Container(
        height: isBannerLoaded ? 50 : 0,
        color: Styles.primaryColor,
        child: buildAdWidget(),
      );
    }else if(adsType.contains("6")){
      return Container(
        height: isBannerLoaded ? 50 : 0,
        color: Styles.primaryColor,
        child: showUnityBannerAd(),
      );
    }else if(adsType.contains("1")){
      return Container(
        height: isBannerLoaded ? 50 : 0,
        color: Styles.primaryColor,
        child: showFbBanner(),
      );
    }else{
      return const SizedBox(height: 0,width: 0,);
    }
  }
}
