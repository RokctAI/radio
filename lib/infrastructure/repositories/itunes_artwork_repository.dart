import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/domain/interface/artwork_repository.dart';
import 'package:single_radio/infrastructure/models/response/itunes_search_response.dart';

class ItunesArtworkRepository implements ArtworkRepository {
  ItunesArtworkRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<String?> findArtwork({
    required String artist,
    required String track,
  }) async {
    if (track.isEmpty) return null;

    final url = Uri.parse(
      '${Constant.itunesSearchUrl}'
      '?term=${Uri.encodeQueryComponent(track)}&entity=song',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode != 200) return null;

      final parsed = ItunesSearchResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );

      for (final result in parsed.results) {
        if (result.artistName == artist) return result.artworkUrl100;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
