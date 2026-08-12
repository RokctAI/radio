import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/ads/ads_state.dart';

class AdsNotifier extends StateNotifier<AdsState> {
  AdsNotifier() : super(const AdsState());

  void setFailed() => state = state.copyWith(failed: true);

  void setDismiss() => state = state.copyWith(dismissed: true);

  void reset() => state = const AdsState();
}
