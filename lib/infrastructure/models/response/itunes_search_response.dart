// @JsonKey on a freezed factory parameter is the documented way to map a
// JSON key onto a Dart field name, but the analyzer still reports the
// annotation target as invalid. Scoped here rather than project-wide.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'itunes_search_response.freezed.dart';
part 'itunes_search_response.g.dart';

@freezed
class ItunesSearchResponse with _$ItunesSearchResponse {
  const factory ItunesSearchResponse({
    @Default(<ItunesTrack>[]) List<ItunesTrack> results,
  }) = _ItunesSearchResponse;

  factory ItunesSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ItunesSearchResponseFromJson(json);
}

@freezed
class ItunesTrack with _$ItunesTrack {
  const factory ItunesTrack({
    @JsonKey(name: 'artistName') String? artistName,
    @JsonKey(name: 'artworkUrl100') String? artworkUrl100,
  }) = _ItunesTrack;

  factory ItunesTrack.fromJson(Map<String, dynamic> json) =>
      _$ItunesTrackFromJson(json);
}
