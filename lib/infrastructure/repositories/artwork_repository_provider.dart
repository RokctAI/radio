import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:single_radio/domain/interface/artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/chained_artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/deezer_artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/itunes_artwork_repository.dart';

/// Deezer first, iTunes as fallback -- the order the notifier used to encode
/// in its call chain. Override this provider in tests to supply a fake.
final artworkRepositoryProvider = Provider<ArtworkRepository>(
  (ref) => ChainedArtworkRepository([
    DeezerArtworkRepository(),
    ItunesArtworkRepository(),
  ]),
);
