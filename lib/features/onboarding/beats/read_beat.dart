import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/modules.dart';
import '../../../models/module.dart';
import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// Beat 2: the Education tab in miniature. Its four category cards spring
/// out of the island into the same 2×2 grid the real tab uses, then a real
/// module card rises with its text lines drawing in. At the explore beat
/// the cards collapse into the first four map markers — the match cut.
class ReadBeat extends StatelessWidget {
  const ReadBeat({
    super.key,
    required this.time,
    required this.parallax,
    required this.geometry,
  });

  final ValueListenable<double> time;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  static const _icons = {
    ModuleCategory.ecology: Icons.eco_outlined,
    ModuleCategory.history: Icons.history_edu_outlined,
    ModuleCategory.geology: Icons.landscape_outlined,
    ModuleCategory.community: Icons.groups_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([time, parallax]),
      builder: (context, _) {
        final t = time.value;
        if (t < OnboardingTiming.tileFlyStart ||
            t > OnboardingTiming.tileCollapse.$2) {
          return const SizedBox.shrink();
        }
        return Stack(children: _children(t));
      },
    );
  }

  List<Widget> _children(double t) {
    final stage = geometry.layout.stage;
    final drag = parallax.value * 0.6;
    final gridWidth = stage.width.clamp(0.0, 380.0);
    final tileHeight = (stage.height * 0.16).clamp(52.0, 72.0);
    const gap = AppSpace.sm + 2;
    final tileWidth = (gridWidth - gap) / 2;
    final gridLeft = stage.center.dx - gridWidth / 2;
    final gridTop = stage.top + stage.height * 0.04;
    final collapse = segOf(
      t,
      OnboardingTiming.tileCollapse,
      OnboardingCurves.exit,
    );
    final pose = cameraAt(t);

    final children = <Widget>[];
    for (final (i, category) in ModuleCategory.values.indexed) {
      final slot = Rect.fromLTWH(
        gridLeft + (i % 2) * (tileWidth + gap),
        gridTop + (i ~/ 2) * (tileHeight + gap),
        tileWidth,
        tileHeight,
      ).shift(drag);
      final start =
          OnboardingTiming.tileFlyStart + i * OnboardingTiming.tileStagger;
      final fly = seg(
        t,
        start,
        start + OnboardingTiming.tileFlyLength,
        OnboardingCurves.float,
      );
      final appear = seg(t, start, start + 200);

      // Fly out from the island's center; collapse into a marker.
      var center = Offset.lerp(stage.center, slot.center, fly)!;
      var scale = lerpDouble(0.2, 1, fly)!;
      final marker = geometry.project(
        geometry.poiPoints[geometry.dropOrder[i]],
        pose,
        Offset.zero,
      );
      center = Offset.lerp(center, marker, collapse)!;
      scale *= 1 - collapse * 0.95;
      final alpha = appear * (1 - Curves.easeIn.transform(collapse));
      if (alpha <= 0) continue;

      children.add(
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: center,
            width: slot.width,
            height: slot.height,
          ),
          child: Transform.rotate(
            angle: (1 - fly) * -0.18,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: alpha.clamp(0.0, 1.0),
                child: _CategoryTile(
                  label: category.label,
                  icon: _icons[category]!,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final module = allModules.isEmpty ? null : allModules.first;
    if (module != null) {
      final rise = segOf(
        t,
        OnboardingTiming.moduleCardRise,
        OnboardingCurves.land,
      );
      final appear = segOf(t, OnboardingTiming.moduleCardRise) * 3;
      final alpha = appear.clamp(0.0, 1.0) * (1 - collapse);
      final top = gridTop + 2 * tileHeight + gap + AppSpace.md;
      if (alpha > 0) {
        children.add(
          Positioned(
            left: gridLeft + drag.dx * 1.3,
            top: top + (1 - rise) * 70 + collapse * 40 + drag.dy * 1.3,
            width: gridWidth,
            child: Opacity(
              opacity: alpha,
              child: _ModuleCard(
                module: module,
                lines: segOf(t, OnboardingTiming.moduleLinesDraw),
              ),
            ),
          ),
        );
      }
    }
    return children;
  }
}

/// The Education tab's category card, shrunk: surface fill, hairline,
/// heading type.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.depth),
            const SizedBox(width: AppSpace.sm + 2),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.heading.copyWith(fontSize: 15.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A real module, as the module list shows it, with its body text
/// sketched as lines drawing in.
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.lines});

  final Module module;
  final double lines;

  static const _lineWidths = [1.0, 0.94, 0.62];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.sm,
                    vertical: AppSpace.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kelp.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    module.category.label,
                    style: AppText.label.copyWith(color: AppColors.kelp),
                  ),
                ),
                const Spacer(),
                Text(
                  '${module.readMinutes} MIN READ',
                  style: AppText.data.copyWith(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm + 2),
            Text(
              module.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.heading,
            ),
            const SizedBox(height: AppSpace.sm + 2),
            for (final (i, width) in _lineWidths.indexed) ...[
              if (i > 0) const SizedBox(height: 7),
              _SketchLine(
                fraction:
                    width *
                    Curves.easeOutCubic.transform(
                      ((lines * 3) - i * 0.6).clamp(0.0, 1.0),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SketchLine extends StatelessWidget {
  const _SketchLine({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: fraction.clamp(0.001, 1.0),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.shoal,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
