import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:latlong2/latlong.dart';

import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'pmtiles_asset_client.dart';

/// SPIKE: proves the bundled PMTiles archive renders with no network.
/// No markers, no sheet, no filters — those stay on the `island.webp` path
/// in PLAN.md until this approach is adopted or dropped.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _center = LatLng(41.172, -71.578);

  /// The archive's own bounds, read from its PMTiles header.
  static final _islandBounds = LatLngBounds(
    const LatLng(41.11, -71.65),
    const LatLng(41.27, -71.51),
  );

  final _controller = MapController();
  final _client = PmTilesAssetClient('assets/map/blockisland.pmtiles');

  late final Future<vt.Style> _style = _readStyle();

  /// `resolveProvider` is consulted before the style's source URL is looked
  /// at, so the style's remote `pmtiles://latest.protomaps.com` archive is
  /// never contacted — the document still supplies theme and attribution.
  Future<vt.Style> _readStyle() => vt.StyleReader(
        uri: 'asset://assets/map/style.json',
        cache: false,
        logger: const vt.Logger.console(),
        resolveProvider: (sourceId) async => sourceId == 'protomaps'
            ? await vt.PmTilesVectorTileProvider.open(
                PmTilesAssetClient.archiveUrl,
                client: _client,
                logger: const vt.Logger.console(),
              )
            : null,
      ).read();

  @override
  void dispose() {
    _style.then((style) => style.dispose()).ignore();
    _controller.dispose();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: FutureBuilder<vt.Style>(
          future: _style,
          builder: (context, snapshot) {
            final style = snapshot.data;
            if (style == null) return _pending(snapshot.error);
            return _map(style);
          },
        ),
      ),
    );
  }

  Widget _pending(Object? error) => Center(
        child: error == null
            ? const CircularProgressIndicator(color: AppColors.depth)
            : Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Text('Style failed to load.\n$error',
                    style: AppText.caption, textAlign: TextAlign.center),
              ),
      );

  Widget _map(vt.Style style) => FlutterMap(
        mapController: _controller,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 13,
          minZoom: 11,
          maxZoom: 16,
          cameraConstraint: CameraConstraint.contain(bounds: _islandBounds),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          vt.VectorTileLayer(
            theme: style.theme,
            tileProviders: style.providers,
            rasterSources: style.rasterSources,
            sprites: style.sprites,
            logger: const vt.Logger.console(),
          ),
        ],
      );
}
