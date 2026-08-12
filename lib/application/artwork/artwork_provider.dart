import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/artwork/artwork_notifier.dart';
import 'package:single_radio/application/artwork/artwork_state.dart';

final artworkProvider = StateNotifierProvider<ArtworkNotifier, ArtworkState>(
  (ref) => ArtworkNotifier(),
);
