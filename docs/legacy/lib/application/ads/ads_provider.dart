import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/ads/ads_notifier.dart';
import 'package:single_radio/application/ads/ads_state.dart';

final adsProvider = StateNotifierProvider<AdsNotifier, AdsState>(
  (ref) => AdsNotifier(),
);
