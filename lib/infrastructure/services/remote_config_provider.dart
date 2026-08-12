import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/infrastructure/services/remote_config.dart';

/// Overridden in main() with the instance that was initialised and fetched
/// before runApp, so nothing has to await it again.
final remoteConfigProvider = Provider<RemoteConfigService>(
  (ref) => throw UnimplementedError('remoteConfigProvider was not overridden'),
);
