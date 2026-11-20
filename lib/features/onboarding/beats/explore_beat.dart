import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../../../widgets/category_chip.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// Beat 3: the map. The painters drop the markers and draw the course; this
/// layer adds the place counter ticking up and a chart-style callout for
/// one real place, tied to its marker by a leader line.
class ExploreBeat extends StatelessWidget {
  const ExploreBeat({
    super.key,
    required this.time,
    required this.parallax,
    required this.geometry,
  });

  final ValueListenable<double> time;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([time, parallax]),
      builder: (context, _) {
        final t = time.value;
        final careStart = beatStart(OnboardingBeat.care);
        if (t < OnboardingTiming.counterTick.$1 || t > careStart + 500) {
          return const SizedBox.shrink();
        }
        return Stack(children: [_counter(t, careStart), ..._callout(t)]);
      },
    );
  }

  Widget _counter(double t, double careStart) {
    final stage = geometry.layout.stage;
    final total = geometry.pois.length;
    final count =
        (total * segOf(t, OnboardingTiming.counterTick, Curves.easeOutCubic))
            .round();
    final alpha =
        seg(
          t,
          OnboardingTiming.counterTick.$1,
          OnboardingTiming.counterTick.$1 + 300,
        ) *
        (1 - seg(t, careStart, careStart + 400));
    final drag = parallax.value * 0.8;
    return Positioned(
      left: stage.left + drag.dx,
      top: stage.top + drag.dy,
      child: Opacity(
        opacity: alpha,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Padded so the width does not jitter as digits change.
              count.toString().padLeft(total.toString().length, '0'),
              style: AppText.data.copyWith(
                fontSize: 34,
                height: 1,
                color: OnboardingColors.foam,
              ),
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              'PLACES',
              style: AppText.data.copyWith(
                fontSize: 11,
                letterSpacing: 1.6,
                color: OnboardingColors.foamMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _callout(double t) {
    final rise = segOf(t, OnboardingTiming.sheetRise, OnboardingCurves.land);
    final appear = segOf(t, OnboardingTiming.sheetRise) * 2.5;
    final drop = segOf(t, OnboardingTiming.sheetDrop, OnboardingCurves.exit);
    final alpha = appear.clamp(0.0, 1.0) * (1 - drop);
    if (alpha <= 0) return const [];

    final stage = geometry.layout.stage;
    final poi = geometry.pois[geometry.selected];
    final marker = geometry.project(
      geometry.poiPoints[geometry.selected],
      cameraAt(t),
      parallax.value * 0.35,
    );
    final width = (stage.width * 0.78).clamp(0.0, 300.0);
    final left = (marker.dx - width * 0.62)
        .clamp(stage.left, stage.right - width)
        .toDouble();
    // Above the marker, leaving room for the leader line.
    const leader = 22.0;
    final bottom = geometry.layout.size.height - (marker.dy - 12 - leader);
    final lift = (1 - rise) * 22 + drop * 14;

    return [
      Positioned(
        left: marker.dx - 0.5,
        top: marker.dy - 12 - leader * rise,
        width: 1,
        height: leader * rise,
        child: ColoredBox(
          color: OnboardingColors.foam.withValues(alpha: 0.8 * alpha),
        ),
      ),
      Positioned(
        left: left,
        bottom: bottom - lift,
        width: width,
        child: Opacity(
          opacity: alpha,
          child: Transform.scale(
            scale: 0.94 + 0.06 * rise,
            alignment: Alignment.bottomCenter,
            child: _PlaceCard(
              name: poi.name,
              chip: CategoryChip(category: poi.category),
              detail: poi.shortDescription,
              coordinates:
                  '${poi.lat.toStringAsFixed(4)}° N  '
                  '${poi.lng.abs().toStringAsFixed(4)}° W',
            ),
          ),
        ),
      ),
    ];
  }
}

/// The map's place preview, as a floating chart callout.
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.name,
    required this.chip,
    required this.detail,
    required this.coordinates,
  });

  final String name;
  final Widget chip;
  final String detail;
  final String coordinates;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                chip,
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: Text(
                    coordinates,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: AppText.data.copyWith(
                      fontSize: 10.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            Text(name, style: AppText.title.copyWith(fontSize: 20)),
            const SizedBox(height: 2),
            Text(
              detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption,
            ),
          ],
        ),
      ),
    );
  }
}
