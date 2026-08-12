import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_state.freezed.dart';

@freezed
class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    @Default(false) bool isPlaying,
    @Default(false) bool isLoaded,
    @Default(false) bool hasVolume,
    @Default(0) double volume,
    @Default(false) bool backButtonPressed,
    @Default('') String imageUrl,
    List<String>? metadata,
  }) = _PlaybackState;

  const PlaybackState._();

  String get artist => (metadata?.isNotEmpty ?? false) ? metadata![0] : '';
  String get track => ((metadata?.length ?? 0) > 1) ? metadata![1] : '';
}
