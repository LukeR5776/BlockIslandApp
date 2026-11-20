import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/content_index.dart';
import '../../data/modules.dart';
import '../../models/module.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/staggered_entrance.dart';
import '../../widgets/tab_header.dart';
import 'category_screen.dart';

/// Education tab root: the module categories stacked as full-width colored
/// cards under the night-sea header.
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.watch<AppState>().readModuleIds.length;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TabHeader(
          title: 'Education',
          subtitle: '$read of ${allModules.length} modules read',
          accent: AppColors.catEcology,
          icon: Icons.menu_book,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpace.md, AppSpace.lg, AppSpace.md, AppSpace.xl),
          child: Column(
            children: [
              for (final (i, category) in ModuleCategory.values.indexed) ...[
                if (i > 0) const SizedBox(height: AppSpace.md),
                StaggeredEntrance(
                  index: i,
                  child: CategoryBanner(category: category),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A full-width, colored category card with read progress.
class CategoryBanner extends StatefulWidget {
  final ModuleCategory category;

  const CategoryBanner({super.key, required this.category});

  static Color colorFor(ModuleCategory c) => switch (c) {
        ModuleCategory.ecology => AppColors.catEcology,
        ModuleCategory.history => AppColors.catHistory,
        ModuleCategory.geology => AppColors.catGeology,
        ModuleCategory.community => AppColors.catCommunity,
      };

  static IconData iconFor(ModuleCategory c) => switch (c) {
        ModuleCategory.ecology => Icons.eco,
        ModuleCategory.history => Icons.history_edu,
        ModuleCategory.geology => Icons.landscape,
        ModuleCategory.community => Icons.groups,
      };

  @override
  State<CategoryBanner> createState() => _CategoryBannerState();
}

class _CategoryBannerState extends State<CategoryBanner> {
  bool _pressed = false;

  List<Module> get _modules =>
      modulesByCategory[widget.category] ?? const [];

  void _open() {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => CategoryScreen(category: widget.category),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final modules = _modules;
    final read = modules.where((m) => state.isModuleRead(m.id)).length;
    final progress = modules.isEmpty ? 0.0 : read / modules.length;
    final color = CategoryBanner.colorFor(widget.category);
    final subtitle = modules.isEmpty
        ? 'No modules yet'
        : '${modules.length} modules · $read read';

    return Semantics(
      button: true,
      label: '${widget.category.label}, $subtitle',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _open,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Container(
            constraints: const BoxConstraints(minHeight: 128),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, AppColors.headerNight, 0.45)!],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -12,
                  bottom: -18,
                  child: Icon(
                    CategoryBanner.iconFor(widget.category),
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpace.lg - 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CategoryBanner.iconFor(widget.category),
                              color: Colors.white, size: 22),
                          const SizedBox(width: AppSpace.sm),
                          Expanded(
                            child: Text(
                              widget.category.label,
                              style: AppText.title
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          const Icon(Icons.arrow_forward,
                              color: Colors.white70, size: 20),
                        ],
                      ),
                      const SizedBox(height: AppSpace.xs),
                      Text(
                        subtitle,
                        style: AppText.caption
                            .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                      ),
                      const SizedBox(height: AppSpace.md),
                      _ProgressBar(value: progress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animates to its value when it changes, e.g. after reading a module.
class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => LinearProgressIndicator(
            value: v,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
