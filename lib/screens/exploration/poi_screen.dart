import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/content_index.dart';
import '../../models/module.dart';
import '../../models/poi.dart';
import '../../models/quest.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/content_card.dart';
import '../../widgets/quest_tile.dart';
import '../../widgets/section_header.dart';
import '../../widgets/visitor_note.dart';
import '../education/module_screen.dart';

/// Full detail screen for a single POI: image, name, chip, note,
/// description, quests, related modules — pushed from the map sheet.
class PoiScreen extends StatelessWidget {
  final Poi poi;

  const PoiScreen({super.key, required this.poi});

  List<Quest> get _quests => questsByPoiId[poi.id] ?? const [];
  List<Module> get _modules => modulesByPoiId[poi.id] ?? const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpace.xl),
          children: [
            if (poi.imageAsset.isNotEmpty) _PoiImage(asset: poi.imageAsset),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _content(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quest/module sections are omitted entirely (not shown empty) when
  // their list is empty.
  List<Widget> _content(BuildContext context) {
    final note = poi.visitorNote;
    return [
      const SizedBox(height: AppSpace.lg),
      Text(poi.name, style: AppText.title),
      const SizedBox(height: AppSpace.sm),
      CategoryChip(category: poi.category),
      if (note != null) ...[
        const SizedBox(height: AppSpace.md),
        VisitorNote(text: note),
      ],
      const SizedBox(height: AppSpace.lg),
      ..._description(),
      if (_quests.isNotEmpty) ..._questSection(),
      if (_modules.isNotEmpty) ..._moduleSection(context),
    ];
  }

  // Split on double newline so paragraphs get proper spacing, not one block.
  List<Widget> _description() => _spaced([
    for (final paragraph in poi.description.split('\n\n'))
      Text(paragraph, style: AppText.body),
  ], AppSpace.md);

  List<Widget> _questSection() => [
    const SizedBox(height: AppSpace.lg),
    const SectionHeader(title: 'Things to do'),
    const SizedBox(height: AppSpace.md),
    ..._spaced([
      for (final quest in _quests) QuestTile(quest: quest),
    ], AppSpace.sm),
  ];

  List<Widget> _moduleSection(BuildContext context) {
    final state = context.watch<AppState>();
    return [
      const SizedBox(height: AppSpace.lg),
      const SectionHeader(title: 'Learn more'),
      const SizedBox(height: AppSpace.md),
      ..._spaced([
        for (final module in _modules)
          ContentCard(
            title: module.title,
            subtitle: module.summary,
            checked: state.isModuleRead(module.id),
            onTap: () => Navigator.of(context).push(ModuleScreen.route(module)),
          ),
      ], AppSpace.md),
    ];
  }

  // Interposes a fixed gap between items without one trailing the last.
  static List<Widget> _spaced(List<Widget> items, double gap) => [
    for (var i = 0; i < items.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      items[i],
    ],
  ];
}

class _PoiImage extends StatelessWidget {
  final String asset;

  const _PoiImage({required this.asset});

  static const _radius = BorderRadius.vertical(
    bottom: Radius.circular(AppRadius.lg),
  );

  /// Photos may not be bundled yet; a tinted block keeps the layout intact
  /// instead of Flutter's error box.
  static Widget _fallback(BuildContext context, Object error, StackTrace? st) =>
      const ColoredBox(color: AppColors.land);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.asset(asset, fit: BoxFit.cover, errorBuilder: _fallback),
      ),
    );
  }
}
