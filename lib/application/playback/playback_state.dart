import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:single_radio/infrastructure/models/data/track_metadata.dart';

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
    @Default(TrackMetadata()) TrackMetadata metadata,
  }) = _PlaybackState;

  const PlaybackState._();

  String get artist => metadata.artist;
  String get track => metadata.track;
}
