import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/pois.dart';
import '../models/poi.dart';
import '../screens/exploration/pmtiles_asset_client.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import 'category_chip.dart';
import 'map_marker.dart';

class IslandMap extends StatefulWidget {
  final ValueChanged<Poi> onPoiTap;
  final VoidCallback onMapTap;
  final String? selectedPoiId;

  const IslandMap({
    super.key,
    required this.onPoiTap,
    required this.onMapTap,
    this.selectedPoiId,
  });

  @override
  State<IslandMap> createState() => _IslandMapState();
}

class _IslandMapState extends State<IslandMap> {
  static const _center = LatLng(41.172, -71.578);

  /// 44x44 per the native-feel checklist; the 22pt visual centers inside it.
  static const _hitTarget = 44.0;

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

  void _handlePoiTap(Poi poi) {
    HapticFeedback.selectionClick();
    widget.onPoiTap(poi);
  }

  Marker _marker(Poi poi, AppState state) => Marker(
        point: LatLng(poi.lat, poi.lng),
        width: _hitTarget,
        height: _hitTarget,
        child: Semantics(
          button: true,
          label: '${poi.name}, ${CategoryChip.labelFor(poi.category)}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _handlePoiTap(poi),
            child: Center(
              child: MapMarker(
                selected: poi.id == widget.selectedPoiId,
                completed: poi.questIds.any(state.isQuestComplete),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return FutureBuilder<vt.Style>(
      future: _style,
      builder: (context, snapshot) {
        final style = snapshot.data;
        if (style == null) return _pending(snapshot.error);
        return _map(style, state);
      },
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

  Widget _map(vt.Style style, AppState state) => FlutterMap(
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
          onTap: (_, _) => widget.onMapTap(),
        ),
        children: [
          vt.VectorTileLayer(
            theme: style.theme,
            tileProviders: style.providers,
            rasterSources: style.rasterSources,
            sprites: style.sprites,
            logger: const vt.Logger.console(),
          ),
          MarkerLayer(
            markers: [for (final poi in kPois) _marker(poi, state)],
          ),
        ],
      );
}
