import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';

/// Sea spray: drifting points that, in the hero, fly in and settle along the
/// real coastline in path order — the shore is "drawn" by their arrival —
/// then scatter back out to sea when the camera pushes in.
///
/// One `drawRawPoints` call per depth band; positions go into a reused
/// [Float32List], so a frame allocates nothing.
class SprayParticlesPainter extends CustomPainter {
  SprayParticlesPainter({
    required this.time,
    required this.clock,
    required this.parallax,
    required this.count,
    required this.geometry,
  }) : super(repaint: Listenable.merge([time, clock, parallax, count]));

  final ValueListenable<double> time;
  final ValueListenable<double> clock;
  final ValueListenable<Offset> parallax;
  final ValueListenable<int> count;
  final IslandGeometry geometry;

  static const _bands = 3;
  static final _seeds = _Seeds(OnboardingParticles.max);

  final _buffers = [
    for (var b = 0; b < _bands; b++)
      Float32List(OnboardingParticles.max ~/ _bands * 2 + 2),
  ];
  final _lengths = List.filled(_bands, 0);
  final _dot = Paint()
    ..strokeCap = StrokeCap.round
    ..color = OnboardingColors.foam;
  final _halo = Paint()
    ..strokeCap = StrokeCap.round
    ..color = OnboardingColors.seaGlass;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final s = clock.value;
    final n = count.value;
    if (n == 0) return;

    final fadeOut = 1 - segOf(t, OnboardingTiming.dawn, Curves.easeIn);
    if (fadeOut <= 0) return;

    final pose = cameraAt(t);
    final drag = parallax.value;
    final samples = geometry.coastSamples;
    final stride = OnboardingParticles.max / n;
    final center = geometry.center;
    final lengths = _lengths..fillRange(0, _bands, 0);

    // How strongly the whole field is bound to the coast right now — used
    // to brighten the points while they trace the shore.
    var bound = 0.0;

    for (var i = 0; i < n; i++) {
      final seed = _seeds;
      final depth = seed.depth[i];
      // Drift: wraps around the screen, deeper points move and parallax more.
      final dx =
          _wrap(seed.x[i] + seed.vx[i] * s * depth) * size.width +
          drag.dx * depth * 0.6;
      final dy =
          _wrap(seed.y[i] + seed.vy[i] * s * depth) * size.height +
          drag.dy * depth * 0.6;

      // Convergence onto the coast, staggered along the path.
      final start =
          OnboardingTiming.particleConvergeStart +
          i / n * OnboardingTiming.particleConvergeSpread;
      final converge = seg(
        t,
        start,
        start + OnboardingTiming.particleConvergeLength,
        Curves.easeInOutCubic,
      );
      // Release back to sea at the read beat, in a random order.
      final (r0, r1) = OnboardingTiming.particleRelease;
      final releaseStart = r0 + seed.phase[i] / (2 * math.pi) * (r1 - r0) * 0.5;
      final release = seg(t, releaseStart, r1, Curves.easeInCubic);
      final bind = converge * (1 - release);
      bound += bind;

      var x = dx, y = dy;
      if (bind > 0) {
        final si = (i * stride).floor() * 2;
        final target = geometry.project(
          Offset(samples[si], samples[si + 1]),
          pose,
          drag * 0.35,
        );
        // A small shimmer while bound, so the coast sparkles rather than
        // sitting as a static dotted line.
        final shimmer = 0.9 * math.sin(s * 3 + seed.phase[i]);
        x = ui.lerpDouble(dx, target.dx + shimmer, bind)!;
        y = ui.lerpDouble(dy, target.dy + shimmer, bind)!;
        // Scatter outward from the island as they let go.
        if (release > 0 && release < 1) {
          final away = target - center;
          final dist = away.distance;
          if (dist > 0) {
            final push = math.sin(release * math.pi) * 36;
            x += away.dx / dist * push;
            y += away.dy / dist * push;
          }
        }
      }

      final band = i % _bands;
      final buffer = _buffers[band];
      buffer[lengths[band]++] = x;
      buffer[lengths[band]++] = y;
    }

    final glow = (bound / n).clamp(0.0, 1.0);
    for (var b = 0; b < _bands; b++) {
      final points = Float32List.sublistView(_buffers[b], 0, lengths[b]);
      final dotSize = 1.3 + b * 0.75;
      final alpha = (0.28 + b * 0.16 + glow * 0.35) * fadeOut;
      canvas.drawRawPoints(
        ui.PointMode.points,
        points,
        _halo
          ..strokeWidth = dotSize * 3.2
          ..color = OnboardingColors.seaGlass.withValues(alpha: alpha * 0.18),
      );
      canvas.drawRawPoints(
        ui.PointMode.points,
        points,
        _dot
          ..strokeWidth = dotSize
          ..color = OnboardingColors.foam.withValues(alpha: alpha.clamp(0, 1)),
      );
    }
  }

  static double _wrap(double v) => v - v.floorToDouble();

  @override
  bool shouldRepaint(SprayParticlesPainter old) =>
      old.geometry != geometry || old.count != count || old.time != time;
}

/// Fixed-seed particle parameters: the same field on every launch.
class _Seeds {
  _Seeds(int n)
    : x = Float32List(n),
      y = Float32List(n),
      vx = Float32List(n),
      vy = Float32List(n),
      depth = Float32List(n),
      phase = Float32List(n) {
    final rng = math.Random(41);
    for (var i = 0; i < n; i++) {
      x[i] = rng.nextDouble();
      y[i] = rng.nextDouble();
      // Mostly a slow drift up and to the right, like wind-blown spray.
      vx[i] = 0.004 + rng.nextDouble() * 0.010;
      vy[i] = -(0.002 + rng.nextDouble() * 0.008);
      depth[i] = 0.35 + rng.nextDouble() * 0.65;
      phase[i] = rng.nextDouble() * 2 * math.pi;
    }
  }

  final Float32List x, y, vx, vy, depth, phase;
}
