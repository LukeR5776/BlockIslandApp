import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';

/// The living background: night water lit by slow-moving pools of color,
/// faint depth contours, and a vignette. At landfall it warms to dawn and
/// then drains to the app's paper color.
///
/// Pools are radial gradients drawn as circles of their own radius rather
/// than full-screen fills, which keeps fill-rate low on large screens.
class AuroraPainter extends CustomPainter {
  AuroraPainter({
    required this.time,
    required this.clock,
    required this.parallax,
  }) : super(repaint: Listenable.merge([time, clock, parallax]));

  final ValueListenable<double> time;
  final ValueListenable<double> clock;
  final ValueListenable<Offset> parallax;

  static const _pools = [
    // (color, alpha, radius × longest side, center x, center y, speed, phase)
    (OnboardingColors.glow, 0.55, 0.75, 0.15, 0.20, 0.07, 0.0),
    (OnboardingColors.seaGlass, 0.30, 0.55, 0.85, 0.35, 0.05, 1.7),
    (OnboardingColors.swell, 0.70, 0.85, 0.55, 0.85, 0.04, 3.1),
    (OnboardingColors.beacon, 0.16, 0.45, 0.80, 0.80, 0.06, 4.4),
  ];

  // Where each pool's color goes at dawn.
  static const _dawnPools = [
    OnboardingColors.dawnHigh,
    OnboardingColors.dawn,
    OnboardingColors.glow,
    OnboardingColors.dawn,
  ];

  final _paint = Paint();
  final _contour = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final s = clock.value;
    final drag = parallax.value * 0.25;
    final dawn = segOf(t, OnboardingTiming.dawn, Curves.easeInOut);
    final paper = segOf(t, OnboardingTiming.paper, Curves.easeInOutCubic);
    final rect = Offset.zero & size;

    if (paper >= 1) {
      canvas.drawRect(rect, _paint..color = AppColors.paper);
      return;
    }

    // Paint color alpha multiplies shaders; reset it, since the paper fill
    // below leaves it translucent for the next frame.
    _paint.color = const Color(0xFF000000);
    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(OnboardingColors.night, OnboardingColors.sea, dawn)!,
        Color.lerp(OnboardingColors.sea, OnboardingColors.swell, dawn)!,
      ],
    ).createShader(rect);
    canvas.drawRect(rect, _paint);

    final longest = size.longestSide;
    // The whole field drifts slightly upward as the story advances — a slow
    // vertical parallax under the faster camera moves on the stage.
    final storyDrift = -t / OnboardingTiming.total * 0.06 * size.height;
    for (final (i, pool) in _pools.indexed) {
      final (color, alpha, radius, cx, cy, speed, phase) = pool;
      final a = s * speed * 2 * math.pi + phase;
      final center =
          Offset(
            (cx + 0.12 * math.sin(a) + 0.05 * math.sin(a * 2.3)) * size.width,
            (cy + 0.09 * math.cos(a * 1.3)) * size.height + storyDrift,
          ) +
          drag;
      final r = radius * longest * (1 + 0.08 * math.sin(a * 0.7));
      final c = Color.lerp(color, _dawnPools[i], dawn)!;
      final al = alpha * (1 + 0.4 * dawn).clamp(0, 1);
      _paint.shader = RadialGradient(
        colors: [
          c.withValues(alpha: al),
          c.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
      canvas.drawCircle(center, r, _paint);
    }
    _paint.shader = null;

    _paintContours(canvas, size, s, drag, 1 - dawn);

    // Vignette pulls the eye to the island and steadies the edges.
    _paint.shader = RadialGradient(
      radius: 0.9,
      colors: [
        const Color(0x00000000),
        OnboardingColors.night.withValues(alpha: 0.6 * (1 - dawn)),
      ],
      stops: const [0.55, 1],
    ).createShader(rect);
    canvas.drawRect(rect, _paint);
    _paint.shader = null;

    if (paper > 0) {
      canvas.drawRect(
        rect,
        _paint..color = AppColors.paper.withValues(alpha: paper),
      );
    }
  }

  // Depth contours, as on a chart: a few faint swell lines drifting slowly.
  void _paintContours(
    Canvas canvas,
    Size size,
    double s,
    Offset drag,
    double strength,
  ) {
    if (strength <= 0) return;
    _contour.color = OnboardingColors.foam.withValues(alpha: 0.05 * strength);
    const lines = 5;
    const steps = 36;
    for (var l = 0; l < lines; l++) {
      final baseY = size.height * (0.12 + l * 0.2) + drag.dy * 0.5;
      final path = Path();
      for (var k = 0; k <= steps; k++) {
        final x = size.width * k / steps;
        final y =
            baseY +
            14 * math.sin(k / steps * 2 * math.pi * 1.3 + s * 0.35 + l) +
            6 * math.sin(k / steps * 2 * math.pi * 3.1 - s * 0.2 + l * 2);
        k == 0 ? path.moveTo(x + drag.dx, y) : path.lineTo(x + drag.dx, y);
      }
      canvas.drawPath(path, _contour);
    }
  }

  @override
  bool shouldRepaint(AuroraPainter old) =>
      old.time != time || old.clock != clock || old.parallax != parallax;
}
