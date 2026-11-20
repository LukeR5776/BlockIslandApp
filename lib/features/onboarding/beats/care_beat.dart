import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/content_index.dart';
import '../../../theme/onboarding_tokens.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// Beat 4: the Conservation tab's organizations float up as kelp pills,
/// bobbing gently while the compass rose draws in behind them.
///
/// Builds a [Positioned], so it must sit directly in the overlay's Stack.
class CareBeat extends StatelessWidget {
  const CareBeat({
    super.key,
    required this.time,
    required this.clock,
    required this.parallax,
    required this.geometry,
  });

  final ValueListenable<double> time;
  final ValueListenable<double> clock;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  /// Three names fit without burying the island; the rest are counted.
  static const _shown = 3;

  // The three most conservation-focused first, by curated ID.
  static const _preferred = [
    'the-nature-conservancy',
    'block-island-maritime-institute',
    'block-island-historical-society',
  ];

  static List<String> get _labels {
    final orgs = [...conservationOrganizations]
      ..sort((a, b) {
        int rank(String id) {
          final i = _preferred.indexOf(id);
          return i < 0 ? _preferred.length : i;
        }

        return rank(a.id).compareTo(rank(b.id));
      });
    return [
      for (final org in orgs.take(_shown)) org.name,
      if (orgs.length > _shown) '+ ${orgs.length - _shown} more',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final labels = _labels;
    return ListenableBuilder(
      listenable: Listenable.merge([time, clock, parallax]),
      builder: (context, _) {
        final t = time.value;
        final landfall = beatStart(OnboardingBeat.landfall);
        if (t < OnboardingTiming.orgFloatStart || t > landfall + 500) {
          return const SizedBox.shrink();
        }
        final stage = geometry.layout.stage;
        final leave = seg(t, landfall, landfall + 450, OnboardingCurves.exit);
        final drag = parallax.value * 0.9;
        return Positioned(
          left: stage.left + drag.dx,
          right: geometry.layout.size.width - stage.right - drag.dx,
          bottom: geometry.layout.size.height - stage.bottom - drag.dy,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final (i, label) in labels.indexed)
                _pill(label, i, t, leave),
            ],
          ),
        );
      },
    );
  }

  Widget _pill(String label, int i, double t, double leave) {
    final start =
        OnboardingTiming.orgFloatStart + i * OnboardingTiming.orgStagger;
    final float = seg(
      t,
      start,
      start + OnboardingTiming.orgFloatLength,
      OnboardingCurves.float,
    );
    final appear = seg(t, start, start + 220);
    final bob = math.sin(clock.value * 1.4 + i * 1.9) * 2.5;
    final alpha = (appear * (1 - leave)).clamp(0.0, 1.0);
    final more = label.startsWith('+');
    return Transform.translate(
      offset: Offset(0, (1 - float) * 34 + bob - leave * 16),
      child: Opacity(
        opacity: alpha,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: more
                ? OnboardingColors.night.withValues(alpha: 0.55)
                : OnboardingColors.kelp,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: OnboardingColors.kelpLight.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            label,
            style: AppText.label.copyWith(
              fontSize: 13,
              color: OnboardingColors.foam,
            ),
          ),
        ),
      ),
    );
  }
}
