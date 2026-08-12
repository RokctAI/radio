import 'package:flutter_test/flutter_test.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/infrastructure/models/data/track_metadata.dart';

void main() {
  setUp(() {
    Constant.appName = 'Musina FM';
    Constant.titleSeparators = const [' - ', ' – ', ' | ', '-'];
  });

  group('TrackMetadata.fromIcy', () {
    test('keeps the split radio_player already made', () {
      final metadata = TrackMetadata.fromIcy(['Artist', 'Track', 'cover.jpg']);

      expect(metadata.artist, 'Artist');
      expect(metadata.track, 'Track');
      expect(metadata.artworkUrl, 'cover.jpg');
      expect(metadata.hasArtwork, isTrue);
    });

    test('splits an unspaced hyphen the plugin leaves alone', () {
      // The real title observed on this station's Zeno mount. radio_player
      // only splits on " - ", so it arrives as one field and the track -- the
      // headline, and the artwork search term -- would otherwise be empty.
      final metadata = TrackMetadata.fromIcy(
        ['CSG & 24Swagg-Ndia Mutakalela ft (M-flows) Beatz', '', ''],
      );

      expect(metadata.artist, 'CSG & 24Swagg');
      expect(metadata.track, 'Ndia Mutakalela ft (M-flows) Beatz');
    });

    test('splits on the first candidate that matches, not the first hyphen',
        () {
      final metadata = TrackMetadata.fromIcy(['Jay-Z - Song Title', '', '']);

      expect(metadata.artist, 'Jay-Z');
      expect(metadata.track, 'Song Title');
    });

    test('falls back to the station name so the headline is never blank', () {
      final metadata = TrackMetadata.fromIcy(['Unstructured Title', '', '']);

      expect(metadata.artist, 'Musina FM');
      expect(metadata.track, 'Unstructured Title');
    });

    test('pads a short triple rather than throwing', () {
      final metadata = TrackMetadata.fromIcy(['Artist', 'Track']);

      expect(metadata.artworkUrl, isEmpty);
      expect(metadata.hasArtwork, isFalse);
    });

    test('reports empty when the stream sends nothing', () {
      expect(TrackMetadata.fromIcy(['', '', '']).isEmpty, isTrue);
    });
  });
}
