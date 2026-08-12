/// Resolves cover art for a track when the stream carries none of its own.
///
/// Implementations are interchangeable and additive: callers depend on this
/// facade, never on a named service, so adding or reordering providers does
/// not touch the application layer.
abstract class ArtworkRepositoryFacade {
  /// Returns an artwork URL, or null when this source has no match.
  Future<String?> findArtwork({required String artist, required String track});
}
