import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radio_player/radio_player.dart';
import 'package:volume_regulator/volume_regulator.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/application/artwork/artwork_provider.dart';
import 'package:single_radio/application/playback/playback_state.dart';
import 'package:single_radio/domain/interface/artwork.dart';
import 'package:single_radio/infrastructure/models/data/track_metadata.dart';
import 'package:single_radio/infrastructure/services/interstitial_ad.dart';
import 'package:single_radio/utils/app_pref.dart';

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  PlaybackNotifier(this._ref, this._artworkRepository)
      : super(const PlaybackState()) {
    initRadioPlayer();
  }

  final Ref _ref;
  final ArtworkRepositoryFacade _artworkRepository;

  final RadioPlayer radioPlayer = RadioPlayer();
  final AdmobHelper admobHelper = AdmobHelper();

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
        final metadata = TrackMetadata.fromIcy(value);
        state = state.copyWith(metadata: metadata);

        if (metadata.hasArtwork) {
          _publishArtwork(metadata.artworkUrl);
        } else {
          await _resolveArtwork(metadata);
        }
      });
    } catch (e) {
      debugPrint('Error initializing radio player: $e');
    }
  }

  /// The stream carried no cover, so ask the configured sources in order.
  Future<void> _resolveArtwork(TrackMetadata metadata) async {
    if (metadata.isEmpty) return;

    final url = await _artworkRepository.findArtwork(
      artist: metadata.artist,
      track: metadata.track,
    );

    if (url == null || url.isEmpty) {
      state = state.copyWith(imageUrl: '');
      return;
    }

    _publishArtwork(url);
    radioPlayer.setDefaultArtwork(url);
  }

  void _publishArtwork(String url) {
    state = state.copyWith(imageUrl: url);
    _ref.read(artworkProvider.notifier).setImageUrl(url);
  }

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
