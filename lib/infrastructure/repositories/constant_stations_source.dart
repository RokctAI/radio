import 'package:radio_sdk/radio_sdk.dart';

import 'package:single_radio/app_constants.dart';

/// Host adapter: serves the single station this app is branded for.
///
/// radio_sdk defaults to FrappeStationsSource, which needs a tenant site. This
/// app has no backend yet, so the host registers this instead and the SDK's
/// isRegistered guard leaves it in place. Swapping to the Frappe source later
/// means deleting this registration, not touching the SDK.
class ConstantStationsSource implements StationsSourceFacade {
  const ConstantStationsSource();

  @override
  Future<List<Station>> fetch() async => [
        Station(
          id: 'default',
          name: Constant.appName,
          streamUrl: Constant.streamUrl,
          titleSeparators: Constant.titleSeparators,
          isActive: true,
          updatedAt: DateTime.now(),
        ),
      ];
}
