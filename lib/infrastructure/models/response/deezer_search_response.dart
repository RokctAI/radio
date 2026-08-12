// @JsonKey on a freezed factory parameter is the documented way to map a
// JSON key onto a Dart field name, but the analyzer still reports the
// annotation target as invalid. Scoped here rather than project-wide.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deezer_search_response.freezed.dart';
part 'deezer_search_response.g.dart';

@freezed
class DeezerSearchResponse with _$DeezerSearchResponse {
  const factory DeezerSearchResponse({
    @Default(<DeezerSong>[]) List<DeezerSong> data,
  }) = _DeezerSearchResponse;

  factory DeezerSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$DeezerSearchResponseFromJson(json);
}

@freezed
class DeezerSong with _$DeezerSong {
  const factory DeezerSong({
    DeezerArtist? artist,
    DeezerAlbum? album,
  }) = _DeezerSong;

  factory DeezerSong.fromJson(Map<String, dynamic> json) =>
      _$DeezerSongFromJson(json);
}

@freezed
class DeezerArtist with _$DeezerArtist {
  const factory DeezerArtist({String? name}) = _DeezerArtist;

  factory DeezerArtist.fromJson(Map<String, dynamic> json) =>
      _$DeezerArtistFromJson(json);
}

@freezed
class DeezerAlbum with _$DeezerAlbum {
  const factory DeezerAlbum({
    @JsonKey(name: 'cover_big') String? coverBig,
  }) = _DeezerAlbum;

  factory DeezerAlbum.fromJson(Map<String, dynamic> json) =>
      _$DeezerAlbumFromJson(json);
}
