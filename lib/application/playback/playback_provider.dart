import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/playback/playback_notifier.dart';
import 'package:single_radio/application/playback/playback_state.dart';

final playbackProvider =
    StateNotifierProvider<PlaybackNotifier, PlaybackState>(
  (ref) => PlaybackNotifier(ref),
);
