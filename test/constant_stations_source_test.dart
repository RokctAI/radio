import 'package:flutter_test/flutter_test.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/infrastructure/repositories/constant_stations_source.dart';

void main() {
  setUp(() {
    Constant.appName = 'Musina FM';
    Constant.streamUrl = 'https://stream.zeno.fm/jsaf9vnqd0wtv';
    Constant.titleSeparators = const [' - ', '-'];
  });

  group('ConstantStationsSource', () {
    test('serves one active, playable station from config', () async {
      final stations = await const ConstantStationsSource().fetch();

      expect(stations, hasLength(1));
      expect(stations.single.name, 'Musina FM');
      expect(stations.single.streamUrl, isNotEmpty);
      expect(stations.single.isActive, isTrue);
      expect(stations.single.isPlayable, isTrue);
    });

    test('carries the configured separators through to the station', () async {
      final station = (await const ConstantStationsSource().fetch()).single;

      // The player uses these to split ICY titles; an empty list would send
      // it back to the SDK defaults, which is not what this station needs.
      expect(station.titleSeparators, [' - ', '-']);
    });

    test('reports unplayable when no stream is configured', () async {
      Constant.streamUrl = '';

      final station = (await const ConstantStationsSource().fetch()).single;

      // StationsRepository filters these out rather than tuning to nothing.
      expect(station.isPlayable, isFalse);
    });
  });
}
