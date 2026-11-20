import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/content_index.dart';
import '../../models/module.dart';
import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/content_card.dart';
import '../../widgets/empty_state.dart';
import 'module_screen.dart';

/// Module list for one Education category, with read checkmarks.
class CategoryScreen extends StatelessWidget {
  final ModuleCategory category;

  const CategoryScreen({super.key, required this.category});

  List<Module> get _modules => modulesByCategory[category] ?? const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: _list(context)),
    );
  }

  Widget _list(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.md,
        AppSpace.sm,
        AppSpace.md,
        AppSpace.xl,
      ),
      children: [
        Text(category.label, style: AppText.title),
        if (_modules.isEmpty)
          EmptyState(message: '${category.label} modules will be listed here.'),
        for (final module in _modules) ...[
          const SizedBox(height: AppSpace.md),
          ContentCard(
            title: module.title,
            subtitle: module.summary,
            checked: state.isModuleRead(module.id),
            onTap: () => Navigator.of(context).push(ModuleScreen.route(module)),
          ),
        ],
      ],
    );
  }
}
