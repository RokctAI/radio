import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/domain/interface/artwork.dart';
import 'package:single_radio/infrastructure/models/response/deezer_search_response.dart';

class DeezerArtworkRepository implements ArtworkRepositoryFacade {
  DeezerArtworkRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<String?> findArtwork({
    required String artist,
    required String track,
  }) async {
    // Deezer runs through RapidAPI; with no key configured this source is
    // simply absent rather than an error, and the chain moves on.
    final apiKey = Constant.deezerApiKey;
    if (apiKey.isEmpty || track.isEmpty) return null;

    final url = Uri.parse(
      '${Constant.deezerSearchUrl}?q=${Uri.encodeQueryComponent(track)}',
    );

    try {
      final response = await _client.get(
        url,
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': Constant.deezerSearchHost,
        },
      );
      if (response.statusCode != 200) return null;

      final parsed = DeezerSearchResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );

      for (final song in parsed.data) {
        if (song.artist?.name == artist) return song.album?.coverBig;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
