import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/content_index.dart';
import '../../models/conservation_action.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/content_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/staggered_entrance.dart';
import '../../widgets/tab_header.dart';
import '../exploration/poi_screen.dart';
import 'action_screen.dart';

/// Conservation tab root: island organizations, then actions grouped by
/// kind. Kinds with no actions are omitted rather than shown empty.
class ConservationScreen extends StatelessWidget {
  const ConservationScreen({super.key});

  static Iterable<ActionKind> get _kindsWithActions =>
      ActionKind.values.where((k) => actionsByKind[k]?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TabHeader(
          title: 'Conservation',
          subtitle: '${conservationOrganizations.length} island organizations, '
              'and ways to help them.',
          accent: AppColors.kelp,
          icon: Icons.eco,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.md,
            0,
            AppSpace.md,
            AppSpace.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._organizations(context),
              for (final kind in _kindsWithActions) ..._actions(context, kind),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _organizations(BuildContext context) => [
    const SizedBox(height: AppSpace.lg),
    SectionHeader(
      title: 'Organizations',
      count: conservationOrganizations.length,
    ),
    for (final (i, poi) in conservationOrganizations.indexed) ...[
      const SizedBox(height: AppSpace.md),
      StaggeredEntrance(
        index: i,
        child: ContentCard(
        title: poi.name,
        subtitle: poi.shortDescription,
        category: poi.category,
        imageAsset: poi.imageAsset,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => PoiScreen(poi: poi))),
        ),
      ),
    ],
  ];

  List<Widget> _actions(BuildContext context, ActionKind kind) {
    final state = context.watch<AppState>();
    final actions = actionsByKind[kind] ?? const [];
    return [
      const SizedBox(height: AppSpace.lg),
      SectionHeader(title: kind.label, count: actions.length),
      for (final action in actions) ...[
        const SizedBox(height: AppSpace.md),
        ContentCard(
          title: action.title,
          checked: state.isActionCommitted(action.id),
          onTap: () => Navigator.of(context).push(ActionScreen.route(action)),
        ),
      ],
    ];
  }
}
