import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:single_radio/application/playback/playback_notifier.dart';
import 'package:single_radio/application/playback/playback_state.dart';
import 'package:single_radio/domain/interface/artwork.dart';

/// Repositories come from get_it, state from riverpod -- the split the fleet
/// uses. RadioSdkDependencies.register decides which implementation is bound,
/// so a test registers a fake before building the container.
final playbackProvider = StateNotifierProvider<PlaybackNotifier, PlaybackState>(
  (ref) => PlaybackNotifier(ref, GetIt.instance<ArtworkRepositoryFacade>()),
);
