import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'package:volume_regulator/volume_regulator.dart';

import '../ads/InterstitialAd.dart';
import '../utils/Constant.dart';
import '../utils/app_pref.dart';
import 'image_url_notifier.dart';
import 'package:http/http.dart' as http;


class RadioNotifier with ChangeNotifier {
  final RadioPlayer radioPlayer = RadioPlayer();
  ImageUrlNotifier imageUrlNotifier = ImageUrlNotifier();
  bool isPlaying = false;
  bool isLoaded = false;
  bool isGetVol = false;
  List<String>? metadata;
  String imageUrl = '';

  double currentVolume = 0;
  bool isSetSleepTimer = false;

  bool backButtonPressed = false;

  late List<String> imgList;
  late List<Widget> imageSliders;

  final List<Color> colors = [
    Colors.white.withOpacity(0.5),
    Colors.white.withOpacity(0.5),
    Colors.white.withOpacity(0.5),
    Colors.white.withOpacity(0.5),
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  int countAds = 0;
  AdmobHelper admobHelper = AdmobHelper();

  Future<void> loadCount() async {
    countAds = await AppPref.loadSharedPrefInt(Constant.adsInterval);
  }

  Future<void> savedAds() async {
    countAds == 0 ? countAds = 3 : countAds = countAds - 1;
    AppPref.sharedPrefInt(Constant.adsInterval, countAds);
  }

  RadioNotifier() {
    initRadioPlayer();
  }

  Future<void> initRadioPlayer() async {
    await _getCurrentVolume();
    await _initRadioPlayer();
    isGetVol = true;
    isLoaded = true;
    notifyListeners();
  }

  Future<void> _initRadioPlayer() async {
    try {
      radioPlayer.setChannel(
        title: Constant.appName,
        url: Constant.streamUrl,
      );

      radioPlayer.stateStream.listen((value) {
        isPlaying = value;
        notifyListeners();
      });

      radioPlayer.metadataStream.listen((value) {
        metadata = value;
        notifyListeners();
        fetchSongImage();
      });
    } catch (e) {
      print("Error initializing radio player: $e");
    }
  }

  void fetchSongImageFromOther() async {
    const String baseUrl = 'https://itunes.apple.com/search';
    final String searchTerm = metadata![1].toString().replaceAll(' ', '+');
    final String artistName = metadata![0].toString();
    final String url = '$baseUrl?term=$searchTerm&entity=song';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> results = data['results'];
        Map<String, dynamic>? matchedTrack;
        for (var track in results) {
          if (track['artistName'] == artistName) {
            matchedTrack = track;
            break;
          }
        }

        if (matchedTrack != null) {
          imageUrl = matchedTrack['artworkUrl100'];
          notifyListeners();
          imageUrlNotifier.setImageUrl(imageUrl);
          radioPlayer.setDefaultArtwork(imageUrl);
        } else {
          imageUrl = '';
          notifyListeners();
        }
      } else {
        imageUrl = '';
        notifyListeners();
      }
    } catch (e) {
      imageUrl = '';
      notifyListeners();
    }
  }

  void fetchSongImage() async {
    const String apiKey = 'dc203773bdmshebd56d76c1b04b9p11b91djsnb0840e0eb2c7';
    const String baseUrl = 'https://deezerdevs-deezer.p.rapidapi.com/search';
    final String searchTerm = metadata![1].toString();
    final String desiredArtist = metadata![0].toString();

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'deezerdevs-deezer.p.rapidapi.com',
    };

    final String url = '$baseUrl?q=$searchTerm';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          List<dynamic> songs = data['data'];
          Map<String, dynamic>? selectedSong;

          for (var song in songs) {
            if (song.containsKey('artist') &&
                song['artist']['name'] == desiredArtist) {
              selectedSong = song;
              break;
            }
          }

          if (selectedSong != null) {
            if (selectedSong.containsKey('album') &&
                selectedSong['album'].containsKey('cover_big')) {
              String coverBigUrl = selectedSong['album']['cover_big'];
              imageUrl = coverBigUrl;
              notifyListeners();
              imageUrlNotifier.setImageUrl(imageUrl);
              radioPlayer.setDefaultArtwork(imageUrl);
            } else {
              fetchSongImageFromOther();
            }
          } else {
            fetchSongImageFromOther();
          }
        } else {
          fetchSongImageFromOther();
        }
      } else {
        fetchSongImageFromOther();
      }
    } catch (e) {
      fetchSongImageFromOther();
    }
  }

  void togglePlayer() {
    if (isPlaying) {
      radioPlayer.pause();
    } else {
      radioPlayer.play();
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  Future<void> _getCurrentVolume() async {
    VolumeRegulator.getVolume().then((value) {
      currentVolume = value.toDouble();
      notifyListeners();
    });

    VolumeRegulator.volumeStream.listen((value) {
      currentVolume = value.toDouble();
      notifyListeners();
    });
  }

  Future<void> setVolume(double value) async {
    VolumeRegulator.setVolume(value.toInt());
    currentVolume = value.toDouble();
    notifyListeners();
  }

  void pause() {
    radioPlayer.pause();
  }
}