import 'package:get_it/get_it.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/domain/interface/artwork.dart';
import 'package:single_radio/infrastructure/repositories/chained_artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/deezer_artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/itunes_artwork_repository.dart';
import 'package:single_radio/infrastructure/repositories/mock_artwork_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `RadioSdkDependencies.register(GetIt.instance)` for every installed
/// SDK. Registers this SDK's repositories against their facades
/// (idempotently, so a hand-wired host can call it too).
class RadioSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<ArtworkRepositoryFacade>()) {
      getIt.registerSingleton<ArtworkRepositoryFacade>(
        Constant.isDemo
            ? const MockArtworkRepository()
            // Deezer first, iTunes as fallback. Ordering is data here, not
            // control flow in the notifier.
            : ChainedArtworkRepository([
                DeezerArtworkRepository(),
                ItunesArtworkRepository(),
              ]),
      );
    }
  }
}
