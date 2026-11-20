import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/onboarding_tokens.dart';

/// 0→1 progress of [t] through [a, b], shaped by [curve]. Every visual in the
/// sequence is a pure function of timeline time built from this, which is
/// what makes scrubbing backwards and reduce-motion freeze-frames free.
double seg(double t, double a, double b, [Curve curve = Curves.linear]) {
  if (t <= a) return 0;
  if (t >= b) return 1;
  return curve.transform((t - a) / (b - a));
}

/// [seg] over a `(start, end)` token pair.
double segOf(double t, (double, double) range, [Curve curve = Curves.linear]) =>
    seg(t, range.$1, range.$2, curve);

double beatStart(OnboardingBeat beat) => OnboardingTiming.beatStart[beat]!;

double beatEnd(OnboardingBeat beat) => beat == OnboardingBeat.landfall
    ? OnboardingTiming.total
    : beatStart(OnboardingBeat.values[beat.index + 1]);

double settleOf(OnboardingBeat beat) => OnboardingTiming.settle[beat]!;

OnboardingBeat beatAt(double t) {
  for (final beat in OnboardingBeat.values.reversed) {
    if (t >= beatStart(beat)) return beat;
  }
  return OnboardingBeat.hero;
}

/// The master clock: one [AnimationController] whose value *is* the timeline
/// time in milliseconds. Autoplay, taps, scrubs and spring snaps all just
/// move this one number.
class OnboardingTimeline {
  OnboardingTimeline({required TickerProvider vsync})
    : controller = AnimationController(
        vsync: vsync,
        lowerBound: 0,
        upperBound: OnboardingTiming.total,
        duration: Duration(milliseconds: OnboardingTiming.total.round()),
      );

  final AnimationController controller;

  /// Critically damped: a tap fast-forwards through the in-between frames
  /// and lands without overshooting into the following beat.
  static final _spring = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 55,
    ratio: 1,
  );
  static const _tolerance = Tolerance(distance: 2, velocity: 20);

  double get t => controller.value;
  OnboardingBeat get beat => beatAt(t);
  bool get atEnd => t >= OnboardingTiming.total;

  void play() {
    if (!atEnd) controller.forward();
  }

  void seekTo(double target, {double velocity = 0, bool resume = true}) {
    final sim = SpringSimulation(
      _spring,
      t,
      target,
      velocity,
      tolerance: _tolerance,
    );
    // TickerFuture.then fires only on completion, so a seek interrupted by
    // a new gesture does not also restart autoplay.
    controller.animateWith(sim).then((_) {
      if (resume) play();
    });
  }

  /// Tap: jump to the next beat's composed frame.
  void next() {
    final current = beat;
    // Inside the hero, before its copy has settled, a tap completes the
    // hero rather than skipping past the title.
    if (t < settleOf(current)) {
      seekTo(settleOf(current));
    } else if (current != OnboardingBeat.landfall) {
      seekTo(settleOf(OnboardingBeat.values[current.index + 1]));
    }
  }

  void scrubBy(double ms) {
    controller.stop();
    controller.value = (t + ms).clamp(0.0, OnboardingTiming.total);
  }

  /// Drag release: fling direction picks the neighbour; a slow release
  /// snaps to the nearest composed frame.
  void release(double velocityMsPerSecond) {
    final settles = [for (final b in OnboardingBeat.values) settleOf(b)];
    double target;
    if (velocityMsPerSecond.abs() > 1200) {
      target = velocityMsPerSecond > 0
          ? settles.firstWhere(
              (s) => s > t + 1,
              orElse: () => OnboardingTiming.total,
            )
          : settles.lastWhere((s) => s < t - 1, orElse: () => settles.first);
    } else {
      target = settles.reduce((a, b) => (a - t).abs() < (b - t).abs() ? a : b);
    }
    seekTo(target, velocity: velocityMsPerSecond);
  }

  void dispose() => controller.dispose();
}

/// Free-running seconds for ambient life (drift, shimmer, pulses) that must
/// keep moving while the timeline is paused or held on the last beat.
class AmbientClock extends ChangeNotifier implements ValueListenable<double> {
  AmbientClock(TickerProvider vsync, {bool running = true}) {
    _ticker = vsync.createTicker(_tick);
    if (running) _ticker.start();
  }

  late final Ticker _ticker;
  double _seconds = 0;

  @override
  double get value => _seconds;

  void _tick(Duration elapsed) {
    _seconds = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
