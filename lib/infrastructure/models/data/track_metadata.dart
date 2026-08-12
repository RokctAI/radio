import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:single_radio/app_constants.dart';

part 'track_metadata.freezed.dart';

@freezed
class TrackMetadata with _$TrackMetadata {
  const factory TrackMetadata({
    @Default('') String artist,
    @Default('') String track,
    @Default('') String artworkUrl,
  }) = _TrackMetadata;

  const TrackMetadata._();

  bool get hasArtwork => artworkUrl.isNotEmpty;
  bool get isEmpty => artist.isEmpty && track.isEmpty;

  /// Builds the entity from radio_player's raw ICY triple.
  ///
  /// The plugin only splits the stream title on " - " and pads the result to
  /// [title, '', cover] when it finds no match, leaving the track empty. The
  /// UI renders the track as the headline and the artwork lookups use it as
  /// their search term, so an unsplit title costs both.
  ///
  /// Each candidate in [Constant.titleSeparators] is tried in order. If none
  /// matches, the whole title becomes the track and the station name stands in
  /// as the artist, so the headline is never blank.
  factory TrackMetadata.fromIcy(List<String> raw) {
    final values = List<String>.from(raw);
    while (values.length < 3) {
      values.add('');
    }

    final artist = values[0].trim();
    final track = values[1].trim();
    final artworkUrl = values[2].trim();

    if (track.isNotEmpty || artist.isEmpty) {
      return TrackMetadata(
        artist: artist,
        track: track,
        artworkUrl: artworkUrl,
      );
    }

    for (final separator in Constant.titleSeparators) {
      if (separator.isEmpty) continue;
      final at = artist.indexOf(separator);
      if (at > 0 && at < artist.length - separator.length) {
        return TrackMetadata(
          artist: artist.substring(0, at).trim(),
          track: artist.substring(at + separator.length).trim(),
          artworkUrl: artworkUrl,
        );
      }
    }

    return TrackMetadata(
      artist: Constant.appName,
      track: artist,
      artworkUrl: artworkUrl,
    );
  }
}
