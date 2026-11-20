import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// The hero's lighthouse sweep, from Southeast Light's real position: one
/// slow pass of a soft wedge of light across the water and the title.
/// Drawn additively so it brightens whatever it crosses.
class BeamPainter extends CustomPainter {
  BeamPainter({
    required this.time,
    required this.parallax,
    required this.geometry,
  }) : super(repaint: Listenable.merge([time, parallax]));

  final ValueListenable<double> time;
  final ValueListenable<Offset> parallax;
  final IslandGeometry geometry;

  final _beam = Paint()..blendMode = BlendMode.plus;
  final _flare = Paint()..blendMode = BlendMode.plus;

  // Sweep from behind-left round to the lower right, in screen radians
  // (0 = east, y down).
  static const _from = 0.95 * math.pi;
  static const _to = 2.35 * math.pi;
  static const _halfWidth = 0.075 * math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final sweep = segOf(t, OnboardingTiming.beamSweep);
    if (sweep <= 0 || sweep >= 1) return;

    // Brightest mid-sweep; the light "turns on" and fades with the pass.
    final intensity = math.sin(sweep * math.pi);
    final angle = _from + (_to - _from) * Curves.easeInOutSine.transform(sweep);
    final origin = geometry.project(
      geometry.poiPoints[geometry.lighthouse],
      cameraAt(t),
      parallax.value * 0.35,
    );
    final reach = size.longestSide * 1.3;

    final wedge = Path()
      ..moveTo(origin.dx, origin.dy)
      ..arcTo(
        Rect.fromCircle(center: origin, radius: reach),
        angle - _halfWidth,
        _halfWidth * 2,
        false,
      )
      ..close();
    _beam.shader = RadialGradient(
      colors: [
        OnboardingColors.foam.withValues(alpha: 0.34 * intensity),
        OnboardingColors.foam.withValues(alpha: 0.10 * intensity),
        OnboardingColors.foam.withValues(alpha: 0),
      ],
      stops: const [0, 0.35, 1],
    ).createShader(Rect.fromCircle(center: origin, radius: reach));
    canvas.drawPath(wedge, _beam);

    const flareRadius = 26.0;
    _flare.shader = RadialGradient(
      colors: [
        OnboardingColors.foam.withValues(alpha: 0.9 * intensity),
        OnboardingColors.foam.withValues(alpha: 0),
      ],
    ).createShader(Rect.fromCircle(center: origin, radius: flareRadius));
    canvas.drawCircle(origin, flareRadius, _flare);
  }

  @override
  bool shouldRepaint(BeamPainter old) => old.geometry != geometry;
}
