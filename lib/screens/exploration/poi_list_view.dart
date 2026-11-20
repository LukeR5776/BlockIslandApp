import 'package:flutter/material.dart';

import '../../data/content_index.dart';
import '../../data/pois.dart';
import '../../models/poi.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/content_card.dart';
import '../../widgets/section_header.dart';
import 'poi_screen.dart';

enum PoiSort { alphabetical, category }

/// List alternative to the map: every POI as a card, A–Z or grouped by
/// category. Sort lives in MapScreen so it survives switching views.
class PoiListView extends StatelessWidget {
  final PoiSort sort;
  final ValueChanged<PoiSort> onSortChanged;

  const PoiListView({
    super.key,
    required this.sort,
    required this.onSortChanged,
  });

  static int _byName(Poi a, Poi b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  static List<Poi> get _alphabetical => [...kPois]..sort(_byName);

  static Iterable<(PoiCategory, List<Poi>)> get _grouped sync* {
    for (final category in PoiCategory.values) {
      final pois = [...?poisByCategory[category]]..sort(_byName);
      if (pois.isNotEmpty) yield (category, pois);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.md,
        AppSpace.sm,
        AppSpace.md,
        AppSpace.xl,
      ),
      children: [
        _SortMenu(sort: sort, onChanged: onSortChanged),
        ...switch (sort) {
          PoiSort.alphabetical => _alphabeticalCards(context),
          PoiSort.category => _groupedCards(context),
        },
      ],
    );
  }

  List<Widget> _alphabeticalCards(BuildContext context) => [
    for (final poi in _alphabetical) ...[
      const SizedBox(height: AppSpace.md),
      _card(context, poi, showCategory: true),
    ],
  ];

  // The section header already names the category, so cards skip the chip.
  List<Widget> _groupedCards(BuildContext context) => [
    for (final (category, pois) in _grouped) ...[
      const SizedBox(height: AppSpace.lg),
      SectionHeader(title: CategoryChip.labelFor(category), count: pois.length),
      for (final poi in pois) ...[
        const SizedBox(height: AppSpace.md),
        _card(context, poi, showCategory: false),
      ],
    ],
  ];

  Widget _card(BuildContext context, Poi poi, {required bool showCategory}) =>
      ContentCard(
        title: poi.name,
        subtitle: poi.shortDescription,
        category: showCategory ? poi.category : null,
        imageAsset: poi.imageAsset,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => PoiScreen(poi: poi))),
      );
}

class _SortMenu extends StatelessWidget {
  final PoiSort sort;
  final ValueChanged<PoiSort> onChanged;

  const _SortMenu({required this.sort, required this.onChanged});

  static String _label(PoiSort sort) => switch (sort) {
    PoiSort.alphabetical => 'A–Z',
    PoiSort.category => 'By category',
  };

  static const _minTapHeight = 44.0;

  // No elevation: DESIGN.md allows one shadow, on the bottom sheet only.
  static final _menuShape = RoundedRectangleBorder(
    side: const BorderSide(color: AppColors.hairline),
    borderRadius: BorderRadius.circular(AppRadius.md),
  );

  @override
  Widget build(BuildContext context) {
    final style = AppText.bodyStrong.copyWith(color: AppColors.depth);
    return Align(
      alignment: Alignment.centerRight,
      child: PopupMenuButton<PoiSort>(
        initialValue: sort,
        onSelected: onChanged,
        tooltip: 'Sort places',
        color: AppColors.surface,
        elevation: 0,
        shape: _menuShape,
        itemBuilder: (_) => [
          for (final option in PoiSort.values)
            PopupMenuItem(
              value: option,
              child: Text(_label(option), style: style),
            ),
        ],
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minTapHeight),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_label(sort), style: style),
              const Icon(Icons.arrow_drop_down, color: AppColors.depth),
            ],
          ),
        ),
      ),
    );
  }
}
