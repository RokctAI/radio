import 'package:single_radio/domain/interface/artwork_repository.dart';

/// Tries each source in order and returns the first hit.
///
/// This is what the notifier used to do by name, with fetchSongImage falling
/// through to fetchSongImageFromOther on every failure path. Ordering is now
/// data rather than control flow, so a source can be added, removed or
/// reordered without touching the application layer.
class ChainedArtworkRepository implements ArtworkRepository {
  const ChainedArtworkRepository(this._sources);

  final List<ArtworkRepository> _sources;

  @override
  Future<String?> findArtwork({
    required String artist,
    required String track,
  }) async {
    for (final source in _sources) {
      final url = await source.findArtwork(artist: artist, track: track);
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }
}
