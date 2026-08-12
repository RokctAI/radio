/// Resolves cover art for a track when the stream carries none of its own.
///
/// Implementations are interchangeable and additive: the notifier depends on
/// this contract, never on a named service, so adding or reordering providers
/// does not touch the application layer.
abstract class ArtworkRepository {
  /// Returns an artwork URL, or null when this source has no match.
  Future<String?> findArtwork({required String artist, required String track});
}
