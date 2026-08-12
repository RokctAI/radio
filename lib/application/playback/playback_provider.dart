import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/playback/playback_notifier.dart';
import 'package:single_radio/application/playback/playback_state.dart';
import 'package:single_radio/infrastructure/repositories/artwork_repository_provider.dart';

final playbackProvider =
    StateNotifierProvider<PlaybackNotifier, PlaybackState>(
  (ref) => PlaybackNotifier(ref, ref.watch(artworkRepositoryProvider)),
);
