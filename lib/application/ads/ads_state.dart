import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:single_radio/app_constants.dart';

part 'ads_state.freezed.dart';

@freezed
class AdsState with _$AdsState {
  const factory AdsState({
    @Default(false) bool dismissed,
    @Default(false) bool failed,
  }) = _AdsState;

  const AdsState._();

  /// The interstitial outcome the player page branches on.
  String get outcome => dismissed ? Constant.dismiss : Constant.failed;
}
