import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// The island itself — the shared element that carries through every beat.
///
/// Hero: the shore draws itself behind the arriving particles, then fills.
/// Read: a dim, oversized backdrop. Explore: the chart's pale shoal halo.
/// Care: a kelp tint and a compass rose drawing in. Landfall: the app's own
/// chart colors (land fill, depth outline) on paper.
class CoastlinePainter extends CustomPainter {
  CoastlinePainter({
    required this.time,
    required this.parallax,
    required this.geometry,
  }) : super(repaint: Listenable.merge([time, parallax]));

  final ValueListenable<double> time;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  final _fill = Paint();
  final _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  final _tick = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Path? _partial;
  double _partialLength = -1;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final pose = cameraAt(t);
    final drag = parallax.value * 0.35;
    final k = pose.scale;

    final draw = segOf(t, OnboardingTiming.coastDraw, Curves.easeInOut);
    if (draw <= 0) return;
    final fill = segOf(t, OnboardingTiming.coastFill, Curves.easeOut);
    final readDim =
        seg(
          t,
          beatStart(OnboardingBeat.read),
          beatStart(OnboardingBeat.read) + 700,
          Curves.easeOut,
        ) *
        (1 -
            seg(
              t,
              beatStart(OnboardingBeat.explore),
              beatStart(OnboardingBeat.explore) + 700,
              Curves.easeOut,
            ));
    final halo = seg(
      t,
      beatStart(OnboardingBeat.explore) + 300,
      beatStart(OnboardingBeat.explore) + 1100,
      Curves.easeOut,
    );
    final kelp = segOf(t, OnboardingTiming.kelpTint, Curves.easeInOut);
    final chart = segOf(t, OnboardingTiming.chartColors, Curves.easeInOut);

    canvas.save();
    canvas.transform(geometry.matrix(pose, drag));

    final path = draw >= 1 ? geometry.path : _partialPath(draw);

    // Chart shoal tint: the pale band charts draw along a shore.
    if (halo > 0) {
      final haloColor = Color.lerp(
        OnboardingColors.glow,
        AppColors.shoal,
        chart,
      )!;
      canvas.drawPath(
        geometry.path,
        _stroke
          ..strokeWidth = 18 / k
          ..color = haloColor.withValues(
            alpha: 0.22 * halo * (0.6 + 0.4 * chart),
          ),
      );
    }

    if (fill > 0) {
      var land = Color.lerp(
        OnboardingColors.nightLand,
        Color.lerp(OnboardingColors.nightLand, OnboardingColors.kelp, 0.55),
        kelp,
      )!;
      land = Color.lerp(land, AppColors.land, chart)!;
      canvas.drawPath(
        geometry.path,
        _fill..color = land.withValues(alpha: fill * (1 - 0.5 * readDim)),
      );
    }

    // Soft glow under the shoreline, gone by the time we reach paper.
    final glowAlpha = 0.28 * (1 - chart) * (1 - 0.6 * readDim);
    if (glowAlpha > 0) {
      canvas.drawPath(
        path,
        _stroke
          ..strokeWidth = 7 / k
          ..color = OnboardingColors.seaGlass.withValues(alpha: glowAlpha),
      );
    }
    final line = Color.lerp(OnboardingColors.foam, AppColors.depth, chart)!;
    canvas.drawPath(
      path,
      _stroke
        ..strokeWidth = 1.5 / k
        ..color = line.withValues(alpha: 0.95 - 0.5 * readDim),
    );
    canvas.restore();

    _paintCompass(canvas, t, pose, drag, chart);
  }

  Path _partialPath(double draw) {
    final length = geometry.coastLength * draw;
    // Only re-extract when the drawn length has visibly moved.
    if (_partial == null || (length - _partialLength).abs() > 0.5) {
      _partial = geometry.metric.extractPath(0, length);
      _partialLength = length;
    }
    return _partial!;
  }

  /// A compass rose around the island — 72 ticks drawing in clockwise from
  /// north, with a beacon north mark.
  void _paintCompass(
    Canvas canvas,
    double t,
    CameraPose pose,
    Offset drag,
    double chart,
  ) {
    final draw = segOf(t, OnboardingTiming.compassDraw, Curves.easeOutCubic);
    if (draw <= 0) return;
    final center = geometry.project(geometry.center, pose, drag);
    final radius = geometry.islandHeight * pose.scale * 0.62;
    final color = Color.lerp(
      OnboardingColors.foamMuted,
      AppColors.hairline,
      chart,
    )!;
    const ticks = 72;
    final shown = draw * ticks;
    for (var i = 0; i < ticks; i++) {
      final reveal = (shown - i).clamp(0.0, 1.0);
      if (reveal <= 0) break;
      final angle = -math.pi / 2 + i / ticks * 2 * math.pi;
      final major = i % 6 == 0;
      final length = (major ? 10.0 : 5.0) * reveal;
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + dir * radius,
        center + dir * (radius + length),
        _tick
          ..strokeWidth = major ? 1.4 : 1
          ..color = color.withValues(alpha: (major ? 0.75 : 0.45) * reveal),
      );
    }
    // North mark.
    final north = center + Offset(0, -radius - 18);
    final mark = Path()
      ..moveTo(north.dx, north.dy - 5 * draw)
      ..lineTo(north.dx - 4, north.dy + 4)
      ..lineTo(north.dx + 4, north.dy + 4)
      ..close();
    canvas.drawPath(
      mark,
      _fill..color = OnboardingColors.beacon.withValues(alpha: draw),
    );
  }

  @override
  bool shouldRepaint(CoastlinePainter old) => old.geometry != geometry;
}
