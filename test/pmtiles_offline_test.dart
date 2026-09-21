import 'dart:math' as math;

import 'package:block_island/screens/exploration/pmtiles_asset_client.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:flutter_test/flutter_test.dart';

/// SPIKE: proves the bundled archive is readable with no network available.
/// Nothing here opens a socket — if a tile comes back, airplane mode cannot
/// change that.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PmTilesAssetClient client;
  late vt.PmTilesVectorTileProvider provider;

  setUp(() async {
    client = PmTilesAssetClient('assets/map/blockisland.pmtiles');
    provider = await vt.PmTilesVectorTileProvider.open(
      PmTilesAssetClient.archiveUrl,
      client: client,
    );
  });

  tearDown(() {
    provider.dispose();
    client.close();
  });

  test('archive header reports the Block Island zoom range', () {
    expect(provider.minimumZoom, 0);
    expect(provider.maximumZoom, 15);
  });

  test('serves a tile covering the island at the initial zoom', () async {
    final response = await provider.load(_tileFor(41.172, -71.578, 13));

    expect(response, isA<vt.TileResponseData>());
    expect((response as vt.TileResponseData).bytes, isNotEmpty);
  });

  test('reports open ocean west of the island as absent, not as an error',
      () async {
    final response = await provider.load(_tileFor(41.172, -71.9, 13));

    expect(response, isA<vt.TileResponseNotFound>());
  });
}

vt.TileKey _tileFor(double lat, double lon, int z) {
  final n = 1 << z;
  final latRad = lat * math.pi / 180;
  return vt.TileKey(
    z,
    ((lon + 180) / 360 * n).floor(),
    ((1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) / 2 * n)
        .floor(),
  );
}
