import 'package:flutter/material.dart';

import '../../models/poi.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/island_map.dart';
import '../../widgets/primary_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Poi? _selected;

  void _selectPoi(Poi poi) => setState(() => _selected = poi);

  void _clearSelection() {
    if (_selected == null) return;
    setState(() => _selected = null);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IslandMap(
                onPoiTap: _selectPoi,
                onMapTap: _clearSelection,
                selectedPoiId: selected?.id,
              ),
            ),
            if (selected != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _PoiSheet(poi: selected),
              ),
          ],
        ),
      ),
    );
  }
}

/// Inline rather than a modal route: a modal barrier would swallow the map
/// taps that clear the selection.
class _PoiSheet extends StatelessWidget {
  final Poi poi;

  const _PoiSheet({required this.poi});

  static const _decoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    boxShadow: [
      BoxShadow(
        color: AppColors.sheetShadow,
        blurRadius: 24,
        offset: Offset(0, -4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(poi.name, style: AppText.title),
            const SizedBox(height: AppSpace.sm),
            CategoryChip(category: poi.category),
            const SizedBox(height: AppSpace.sm),
            Text(poi.shortDescription, style: AppText.body),
            const SizedBox(height: AppSpace.md),
            PrimaryButton(
              label: 'Read more',
              onPressed: () {
                // TODO(2.3): push PoiScreen
              },
            ),
          ],
        ),
      ),
    );
  }
}
