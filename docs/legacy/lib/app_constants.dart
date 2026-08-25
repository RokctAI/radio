
class Constant {
  static String appName = 'Musina FM';
  static String appMotto = 'Can you handle the Heat?';
  static String streamUrl = 'https://stream.zeno.fm/jsaf9vnqd0wtv';
  //static String streamUrl = 'https://stream.zeno.fm/4w1vq4a2ekhvv'; //metroFM

  //static String streamUrl = 'https://a2.hostingdomain.com:6567/radio.mp3';
  // static String streamUrl = 'https://air.pc.cdn.bitgravity.com/air/live/pbaudio022/master.m3u8';
  static String minAppVersion = '1.2.7';
  static String twitterUrl = 'https://twitter.com';
  static String facebookUrl = 'https://facebook.com/profile.php?id=100076662353886';
  static String whatsappUrl = 'https://api.whatsapp.com/send?phone=27711327578';
  static String privacyUrl = 'https://dbugstation.com/';
  static String aboutUsUrl = 'https://dbugstation.com/about';
  static String rateUsUrl = 'https://play.google.com/store/apps/details?id=app.radio.fm';
  static const String messagingSenderId = "728921419683";
  // Set to false to disable ads
  static bool showADS = false;

  // Selects mock repositories in the DI hook, so the app runs without
  // reaching third-party artwork services. Mirrors base_sdk's
  // AppConstants.isDemo, which CI sets from the Flutter App Configuration
  // doctype's is_demo field.
  static const bool isDemo = bool.fromEnvironment('IS_DEMO');

  static String oneSignalId = '3dc65b9c-6f53-449a-9710-2dcfa2821ce4';

  // radio_player only splits ICY titles on " - ". When a stream uses something
  // else, the whole title arrives as one field. These are tried in order until
  // one is found; the first match wins, so list the more specific forms first.
  // Set to an empty list to always keep the title on one line.
  static List<String> titleSeparators = const [' - ', ' – ', ' | ', '-'];

  // Artwork lookup endpoints, used when a stream carries no cover art of its
  // own and the artist and track have to be searched instead.
  static String itunesSearchUrl = 'https://itunes.apple.com/search';
  static String deezerSearchHost = 'deezerdevs-deezer.p.rapidapi.com';
  static String deezerSearchUrl =
      'https://deezerdevs-deezer.p.rapidapi.com/search';

  // Deezer artwork lookup via RapidAPI. Empty skips Deezer and uses iTunes
  // only. A build-time define like every other secret in the fleet -- the
  // vendor template this lineage came from shipped a key in source, shared
  // with every buyer of the item.
  static const String deezerApiKey =
      String.fromEnvironment('DEEZER_RAPIDAPI_KEY');

  //vinyl movement variable
  //if you want to stop rotating set isRotate false
  static const bool isRotate = true;
  //need to change your desire ads code and ID


  // Admob ads Code & Id For Android
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String openAds = "ca-app-pub-3940256099942544/3419835294";
  static const String bannerAds = "ca-app-pub-3940256099942544/6300978111";
  static const String interAds = "ca-app-pub-3940256099942544/1033173712";

  //Unity App Id & Placement For Android
  static const String unityAppId = "5090247";
  static const String unityInterPlacementId = "Interstitial_Android";
  static const String unityBannerPlacementId = "Banner_Android";

  //facebook ads code For Android
  static const String fbBannerId = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID";
  static const String fbInterstitialId = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID";

  //Admob ads code & Id for IOS
  static const String openAdsIos = "ca-app-pub-3940256099942544/5662855259";
  static const String interAdsIos = "ca-app-pub-3940256099942544/4411468910";
  static const String bannerAdsIos = "ca-app-pub-3940256099942544/2934735716";

  //Unity Placement for IOS
  static const String unityInterPlacementIdIos = "Interstitial_Ios";
  static const String unityBannerPlacementIdIos = "Banner_Ios";

  //Facebook Placement for IOS
  static const String fbBannerIdIos = "fbbanner_id_ios";
  static const String fbInterstitialIdIos= "fbinters_id_ios";

  //if you want to show Admob ads need to
  // set adsKey "0"
  // if facebook ads "1"
  // else Unity ads "2"
  static String adsKey = "3";

  //After showing an ad, how many clicks will show another ad?
  static const int adsIntervalClicks = 1;

  //Unchanged below lines
  static const String dismiss = "1";
  static const String failed = "0";
  static const String myPreference = "mypref";
  static const String adsInterval = "ads_interval";

}