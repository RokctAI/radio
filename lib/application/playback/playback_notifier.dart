import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:radio_player/radio_player.dart';
import 'package:volume_regulator/volume_regulator.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/application/artwork/artwork_provider.dart';
import 'package:single_radio/application/playback/playback_state.dart';
import 'package:single_radio/infrastructure/services/interstitial_ad.dart';
import 'package:single_radio/utils/app_pref.dart';

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  PlaybackNotifier(this._ref) : super(const PlaybackState()) {
    initRadioPlayer();
  }

  final Ref _ref;

  final RadioPlayer radioPlayer = RadioPlayer();
  final AdmobHelper admobHelper = AdmobHelper();

  /// Visualiser bar styling. Presentation constants rather than state.
  static final List<Color> barColors = [
    Colors.white.withValues(alpha: 0.5),
    Colors.white.withValues(alpha: 0.5),
    Colors.white.withValues(alpha: 0.5),
    Colors.white.withValues(alpha: 0.5),
  ];
  static const List<int> barDurations = [900, 700, 600, 800, 500];

  int countAds = 0;

  Future<void> loadCount() async {
    countAds = await AppPref.loadSharedPrefInt(Constant.adsInterval);
  }

  Future<void> savedAds() async {
    countAds == 0 ? countAds = 3 : countAds = countAds - 1;
    await AppPref.sharedPrefInt(Constant.adsInterval, countAds);
  }

  Future<void> initRadioPlayer() async {
    await _getCurrentVolume();
    await _initRadioPlayer();
    state = state.copyWith(hasVolume: true, isLoaded: true);
  }

  Future<void> _initRadioPlayer() async {
    try {
      radioPlayer.setChannel(
        title: Constant.appName,
        url: Constant.streamUrl,
      );

      radioPlayer.stateStream.listen((value) {
        state = state.copyWith(isPlaying: value);
      });

      radioPlayer.metadataStream.listen((value) async {
        final metadata = _normalizeMetadata(value);
        state = state.copyWith(metadata: metadata);
        if (metadata[2].isNotEmpty) {
          _setImageUrl(metadata[2]);
        } else {
          fetchSongImage();
        }
      });
    } catch (e) {
      debugPrint('Error initializing radio player: $e');
    }
  }

  void _setImageUrl(String url) {
    state = state.copyWith(imageUrl: url);
    _ref.read(artworkProvider.notifier).setImageUrl(url);
  }

  /// Normalises an ICY metadata triple into [artist, track, cover].
  ///
  /// radio_player only splits the stream title on " - " and pads the result to
  /// [title, '', cover] when it finds no match, which leaves the track field
  /// empty. The UI renders the track as the headline and the artwork lookups
  /// use it as their search term, so an unsplit title costs both.
  ///
  /// Each candidate in [Constant.titleSeparators] is tried in order. If none
  /// matches, the whole title becomes the track and the station name stands in
  /// as the artist, so the headline is never blank.
  List<String> _normalizeMetadata(List<String> value) {
    final result = List<String>.from(value);
    while (result.length < 3) {
      result.add('');
    }

    if (result[1].trim().isNotEmpty || result[0].trim().isEmpty) {
      return result;
    }

    final title = result[0].trim();

    for (final separator in Constant.titleSeparators) {
      if (separator.isEmpty) continue;
      final at = title.indexOf(separator);
      if (at > 0 && at < title.length - separator.length) {
        result[0] = title.substring(0, at).trim();
        result[1] = title.substring(at + separator.length).trim();
        return result;
      }
    }

    result[0] = Constant.appName;
    result[1] = title;
    return result;
  }

  Future<void> fetchSongImageFromOther() async {
    final searchTerm = state.track.replaceAll(' ', '+');
    final artistName = state.artist;
    final url = '${Constant.itunesSearchUrl}?term=$searchTerm&entity=song';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _clearImageUrl();
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      Map<String, dynamic>? matchedTrack;
      for (final track in results) {
        if (track['artistName'] == artistName) {
          matchedTrack = track;
          break;
        }
      }

      if (matchedTrack != null) {
        _setImageUrl(matchedTrack['artworkUrl100']);
        radioPlayer.setDefaultArtwork(state.imageUrl);
      } else {
        _clearImageUrl();
      }
    } catch (_) {
      _clearImageUrl();
    }
  }

  Future<void> fetchSongImage() async {
    final apiKey = Constant.deezerApiKey;
    if (apiKey.isEmpty) {
      await fetchSongImageFromOther();
      return;
    }

    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': Constant.deezerSearchHost,
    };
    final url = '${Constant.deezerSearchUrl}?q=${state.track}';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        await fetchSongImageFromOther();
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['data'] is! List) {
        await fetchSongImageFromOther();
        return;
      }

      final List<dynamic> songs = data['data'];
      Map<String, dynamic>? selectedSong;
      for (final song in songs) {
        if (song.containsKey('artist') && song['artist']['name'] == state.artist) {
          selectedSong = song;
          break;
        }
      }

      final cover = selectedSong?['album']?['cover_big'];
      if (cover is String) {
        _setImageUrl(cover);
        radioPlayer.setDefaultArtwork(cover);
      } else {
        await fetchSongImageFromOther();
      }
    } catch (_) {
      await fetchSongImageFromOther();
    }
  }

  void _clearImageUrl() => state = state.copyWith(imageUrl: '');

  void togglePlayer() {
    if (state.isPlaying) {
      radioPlayer.pause();
    } else {
      radioPlayer.play();
    }
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void markBackButtonPressed() =>
      state = state.copyWith(backButtonPressed: true);

  Future<void> _getCurrentVolume() async {
    VolumeRegulator.getVolume().then((value) {
      state = state.copyWith(volume: value.toDouble());
    });

    VolumeRegulator.volumeStream.listen((value) {
      state = state.copyWith(volume: value.toDouble());
    });
  }

  Future<void> setVolume(double value) async {
    VolumeRegulator.setVolume(value.toInt());
    state = state.copyWith(volume: value);
  }

  void pause() => radioPlayer.pause();
}
