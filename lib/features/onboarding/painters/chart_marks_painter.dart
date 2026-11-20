import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// Everything plotted on the island: one marker per real POI (the app's
/// beacon chart-light symbol), their sonar pulses, the dashed course line,
/// and the kelp blooms of the care beat.
///
/// Markers stay a fixed screen size at every zoom, as they do on the real
/// map.
class ChartMarksPainter extends CustomPainter {
  ChartMarksPainter({
    required this.time,
    required this.clock,
    required this.parallax,
    required this.geometry,
  }) : super(repaint: Listenable.merge([time, clock, parallax]));

  final ValueListenable<double> time;
  final ValueListenable<double> clock;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  // MapMarker's proportions (rim 22 / ring 20 / core 14) at 70%.
  static const _rim = 7.7;
  static const _ring = 7.0;
  static const _core = 4.9;

  final _fill = Paint();
  final _outline = Paint()..style = PaintingStyle.stroke;
  final _dash = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 1.2;

  // Reused per frame.
  final _screen = <Offset>[];

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    if (t < OnboardingTiming.markerDropStart) return;
    final s = clock.value;
    final pose = cameraAt(t);
    final drag = parallax.value * 0.35;
    final chart = segOf(t, OnboardingTiming.chartColors, Curves.easeInOut);

    _screen
      ..clear()
      ..addAll(geometry.poiPoints.map((p) => geometry.project(p, pose, drag)));

    _paintCourse(canvas, t, chart);

    final n = geometry.pois.length;
    final pulse =
        seg(
          t,
          beatStart(OnboardingBeat.explore) + 1200,
          beatStart(OnboardingBeat.explore) + 1600,
        ) *
        (1 -
            seg(
              t,
              beatStart(OnboardingBeat.care),
              beatStart(OnboardingBeat.care) + 400,
            ));
    final selectedLift =
        segOf(t, OnboardingTiming.sheetRise, Curves.easeOut) *
        (1 - segOf(t, OnboardingTiming.sheetDrop));

    for (var i = 0; i < n; i++) {
      final rank = geometry.dropRank[i];
      final start =
          OnboardingTiming.markerDropStart +
          rank / n * OnboardingTiming.markerDropSpread;
      final drop = seg(
        t,
        start,
        start + OnboardingTiming.markerDropLength,
        OnboardingCurves.land,
      );
      if (drop <= 0) continue;
      final appear = seg(t, start, start + 140);
      final p = _screen[i] + Offset(0, -(1 - drop) * 26);

      // Care: a kelp ring blooms out of each marker once.
      final bloomStart =
          OnboardingTiming.bloomStart + rank / n * OnboardingTiming.bloomSpread;
      final bloom = seg(
        t,
        bloomStart,
        bloomStart + OnboardingTiming.bloomLength,
      );
      if (bloom > 0 && bloom < 1) {
        final e = Curves.easeOutCubic.transform(bloom);
        canvas.drawCircle(
          p,
          _rim + 24 * e,
          _outline
            ..strokeWidth = 1.6
            ..color = OnboardingColors.kelpLight.withValues(
              alpha: 0.75 * (1 - e),
            ),
        );
      }

      // Explore: a slow sonar pulse, each marker on its own phase.
      if (pulse > 0) {
        final phase = (s / 2.4 + rank * 0.137) % 1.0;
        final e = Curves.easeOut.transform(phase);
        canvas.drawCircle(
          p,
          _rim + 14 * e,
          _outline
            ..strokeWidth = 1.2
            ..color = OnboardingColors.beacon.withValues(
              alpha: 0.55 * (1 - e) * pulse,
            ),
        );
      }

      final scale =
          (i == geometry.selected ? 1 + 0.35 * selectedLift : 1.0) *
          (1 - 0.15 * chart);
      _marker(canvas, p, scale * drop.clamp(0.0, 1.15), appear);
    }
  }

  void _marker(Canvas canvas, Offset p, double scale, double alpha) {
    if (scale <= 0 || alpha <= 0) return;
    canvas.drawCircle(
      p,
      _rim * scale,
      _fill..color = AppColors.beacon.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      p,
      _ring * scale,
      _fill..color = AppColors.surface.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      p,
      _core * scale,
      _fill..color = AppColors.beacon.withValues(alpha: alpha),
    );
  }

  /// A dashed plotted course looping through every place, drawn in.
  void _paintCourse(Canvas canvas, double t, double chart) {
    final draw = segOf(t, OnboardingTiming.courseDraw, Curves.easeInOutCubic);
    if (draw <= 0) return;
    final fadeOut =
        1 -
        seg(
          t,
          beatStart(OnboardingBeat.care),
          beatStart(OnboardingBeat.care) + 600,
        );
    final fadeBack = segOf(t, OnboardingTiming.chartColors);
    final alpha = math.max(fadeOut, fadeBack * 0.8);
    if (alpha <= 0) return;

    final order = geometry.courseOrder;
    var total = 0.0;
    for (var k = 0; k < order.length; k++) {
      total +=
          (_screen[order[(k + 1) % order.length]] - _screen[order[k]]).distance;
    }
    var budget = total * draw;
    const on = 5.0, off = 5.0;
    final path = Path();
    for (var k = 0; k < order.length && budget > 0; k++) {
      final a = _screen[order[k]];
      final b = _screen[order[(k + 1) % order.length]];
      final d = b - a;
      final len = math.min(d.distance, budget);
      if (d.distance == 0) continue;
      final dir = d / d.distance;
      for (var x = 0.0; x < len; x += on + off) {
        path
          ..moveTo(a.dx + dir.dx * x, a.dy + dir.dy * x)
          ..lineTo(
            a.dx + dir.dx * math.min(x + on, len),
            a.dy + dir.dy * math.min(x + on, len),
          );
      }
      budget -= d.distance;
    }
    final color = Color.lerp(
      OnboardingColors.foamMuted,
      AppColors.depth,
      chart,
    )!;
    canvas.drawPath(path, _dash..color = color.withValues(alpha: 0.6 * alpha));
  }

  @override
  bool shouldRepaint(ChartMarksPainter old) => old.geometry != geometry;
}
