import 'package:single_radio/domain/interface/artwork.dart';

/// Demo-mode stand-in, selected by [Constant.isDemo] in the DI hook so the
/// player renders without reaching iTunes or Deezer.
class MockArtworkRepository implements ArtworkRepositoryFacade {
  const MockArtworkRepository();

  @override
  Future<String?> findArtwork({
    required String artist,
    required String track,
  }) async =>
      null;
}
