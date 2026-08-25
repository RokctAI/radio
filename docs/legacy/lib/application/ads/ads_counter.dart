import 'package:single_radio/app_constants.dart';
import 'package:single_radio/utils/app_pref.dart';

/// How many interactions until the next interstitial.
///
/// This used to hang off the playback notifier. Ad pacing is not radio's
/// concern, so it stays app-side until promotions_sdk is composed and owns it.
class AdsCounter {
  int _remaining = 0;

  int get remaining => _remaining;
  bool get shouldShow => _remaining == 0;

  Future<void> load() async {
    _remaining = await AppPref.loadSharedPrefInt(Constant.adsInterval);
  }

  Future<void> consume() async {
    _remaining = _remaining == 0 ? 3 : _remaining - 1;
    await AppPref.sharedPrefInt(Constant.adsInterval, _remaining);
  }
}
