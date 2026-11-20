import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';
import '../../theme/onboarding_tokens.dart';
import '../../theme/spacing.dart';
import 'beats/beat_copy.dart';
import 'beats/care_beat.dart';
import 'beats/explore_beat.dart';
import 'beats/landfall_beat.dart';
import 'beats/read_beat.dart';
import 'onboarding_timeline.dart';
import 'painters/aurora_painter.dart';
import 'painters/beam_painter.dart';
import 'painters/chart_marks_painter.dart';
import 'painters/coastline_painter.dart';
import 'painters/spray_particles_painter.dart';
import 'stage.dart';
import 'widgets/beat_progress.dart';

/// The "Landfall" first-launch sequence. Sits above the already-built app
/// and, when finished, cuts a growing hole through itself onto it.
///
/// Every layer is a pure function of one timeline value (ms), so autoplay,
/// tap-to-advance, drag-to-scrub and the reduce-motion freeze-frames all
/// share the same drawing code.
class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({
    super.key,
    required this.onFinished,
    this.freezeAt,
    this.forceReducedMotion = false,
  });

  /// Called once the exit reveal has fully opened.
  final VoidCallback onFinished;

  /// Debug only: hold the timeline at this time (ms) for screenshots.
  final double? freezeAt;

  final bool forceReducedMotion;

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay>
    with TickerProviderStateMixin {
  late final OnboardingTimeline _timeline = OnboardingTimeline(vsync: this);
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: OnboardingTiming.exit,
  );
  late final AnimationController _parallaxReturn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..addListener(_onParallaxReturn);

  AmbientClock? _clock;
  final _parallax = ValueNotifier<Offset>(Offset.zero);
  Offset _parallaxFrom = Offset.zero;
  final _particleCount = ValueNotifier<int>(0);
  final _statusDark = ValueNotifier<bool>(false);

  // One per scene: under reduce motion two scenes coexist mid-crossfade,
  // and a GlobalKey may only be mounted once.
  final _ctaKeys = <ValueListenable<double>, GlobalKey>{};

  /// Reduce motion's fixed times, reused so each scene keeps its identity
  /// (and its button key) across rebuilds.
  final _frozen = <double, AlwaysStoppedAnimation<double>>{};
  final _skipKey = GlobalKey();
  Offset? _revealCenter;

  bool? _reduced;
  final _reducedTime = ValueNotifier<double>(
    OnboardingTiming.settle[OnboardingBeat.hero]!,
  );
  Timer? _reducedTimer;

  StageLayout? _layout;
  IslandGeometry? _geometry;
  double _lastT = 0;

  final _rasterSamples = <int>[];
  bool _sampling = false;

  bool get _exiting => _exit.isAnimating || _exit.isCompleted;

  @override
  void initState() {
    super.initState();
    _timeline.controller.addListener(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduced != null) return;
    // Decided once: flipping the setting mid-sequence keeps the current mode.
    final reduced =
        widget.forceReducedMotion || MediaQuery.disableAnimationsOf(context);
    _reduced = reduced;
    _clock = AmbientClock(this, running: !reduced);

    final size = MediaQuery.sizeOf(context);
    final area = size.width * size.height / OnboardingParticles.referenceArea;
    _particleCount.value = reduced
        ? 0
        : (OnboardingParticles.perReferenceScreen * area).round().clamp(
            OnboardingParticles.min,
            OnboardingParticles.max,
          );

    final freeze = widget.freezeAt;
    if (reduced) {
      if (freeze != null) {
        _reducedTime.value = settleOf(beatAt(freeze));
      } else {
        _scheduleReducedAdvance();
      }
    } else if (freeze != null) {
      _timeline.controller.value = freeze;
    } else {
      _timeline.play();
      _sampling = true;
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
    }
  }

  @override
  void dispose() {
    if (_sampling) SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _reducedTimer?.cancel();
    _timeline.dispose();
    _exit.dispose();
    _parallaxReturn.dispose();
    _clock?.dispose();
    _parallax.dispose();
    _particleCount.dispose();
    _statusDark.dispose();
    _reducedTime.dispose();
    super.dispose();
  }

  // ── Timeline side effects ──────────────────────────────────────────────

  void _onTick() {
    final t = _timeline.t;
    if (t > _lastT) {
      for (final beat in OnboardingBeat.values.skip(1)) {
        final start = beatStart(beat);
        if (_lastT < start && t >= start) HapticFeedback.lightImpact();
      }
      const land = OnboardingTiming.titleLandHaptic;
      if (_lastT < land && t >= land) HapticFeedback.mediumImpact();
    }
    _lastT = t;
    _statusDark.value = segOf(t, OnboardingTiming.paper) > 0.5;
  }

  /// Sheds half the particles if the first ~45 frames show the GPU is
  /// over budget. One decision, early, so the field never visibly thins
  /// mid-story more than once.
  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _rasterSamples.add(timing.rasterDuration.inMicroseconds);
    }
    if (_rasterSamples.length < OnboardingParticles.sampleFrames) return;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _sampling = false;
    final sorted = [..._rasterSamples]..sort();
    if (sorted[sorted.length ~/ 2] > OnboardingParticles.rasterBudgetMicros) {
      _particleCount.value = math.max(
        OnboardingParticles.min ~/ 2,
        _particleCount.value ~/ 2,
      );
    }
  }

  // ── Reduce motion: composed frames only ────────────────────────────────

  OnboardingBeat get _reducedBeat => beatAt(_reducedTime.value);

  void _scheduleReducedAdvance() {
    _reducedTimer?.cancel();
    if (_reducedBeat == OnboardingBeat.landfall) return;
    _reducedTimer = Timer(OnboardingTiming.reducedHold, () => _stepReduced(1));
  }

  void _stepReduced(int delta) {
    final index = (_reducedBeat.index + delta).clamp(
      0,
      OnboardingBeat.values.length - 1,
    );
    final beat = OnboardingBeat.values[index];
    if (beat != _reducedBeat) {
      HapticFeedback.lightImpact();
      setState(() => _reducedTime.value = settleOf(beat));
    }
    _scheduleReducedAdvance();
  }

  // ── Gestures ───────────────────────────────────────────────────────────

  void _onTap() {
    if (_exiting) return;
    HapticFeedback.selectionClick();
    if (_reduced!) {
      _stepReduced(1);
    } else {
      _timeline.next();
    }
  }

  void _onPanStart(DragStartDetails _) {
    _parallaxReturn.stop();
    if (!_reduced!) _timeline.controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_reduced!) return;
    final width = MediaQuery.sizeOf(context).width;
    // Drag left to move forward, as with any pager.
    _timeline.scrubBy(-d.delta.dx / width * OnboardingTiming.scrubPerScreen);
    final p = _parallax.value + d.delta * 0.12;
    _parallax.value = Offset(p.dx.clamp(-36.0, 36.0), p.dy.clamp(-36.0, 36.0));
  }

  void _onPanEnd(DragEndDetails d) {
    final vx = d.velocity.pixelsPerSecond.dx;
    if (_reduced!) {
      if (vx.abs() > 200) _stepReduced(vx < 0 ? 1 : -1);
      return;
    }
    final width = MediaQuery.sizeOf(context).width;
    _timeline.release(-vx / width * OnboardingTiming.scrubPerScreen);
    _parallaxFrom = _parallax.value;
    _parallaxReturn.forward(from: 0);
  }

  void _onParallaxReturn() {
    final v = OnboardingCurves.land.transform(_parallaxReturn.value);
    _parallax.value = Offset.lerp(_parallaxFrom, Offset.zero, v)!;
  }

  // ── Exit ───────────────────────────────────────────────────────────────

  void _start(GlobalKey from) {
    if (_exiting) return;
    HapticFeedback.mediumImpact();
    final box = from.currentContext?.findRenderObject() as RenderBox?;
    _revealCenter = box == null
        ? MediaQuery.sizeOf(context).center(Offset.zero)
        : box.localToGlobal(box.size.center(Offset.zero));
    _timeline.controller.stop();
    _reducedTimer?.cancel();
    setState(() {});
    _exit.forward().then((_) => widget.onFinished());
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final reduced = _reduced!;
    final clock = _clock!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final padding = MediaQuery.paddingOf(context);
        if (_layout?.size != size || _layout?.padding != padding) {
          _layout = StageLayout(size, padding);
          _geometry = IslandGeometry(_layout!);
        }
        final layout = _layout!;
        final geometry = _geometry!;

        final ValueListenable<double> time = reduced
            ? _reducedTime
            : _timeline.controller;

        final Widget scene = reduced
            ? ValueListenableBuilder<double>(
                valueListenable: _reducedTime,
                builder: (context, t, _) => AnimatedSwitcher(
                  duration: OnboardingTiming.reducedFade,
                  child: KeyedSubtree(
                    key: ValueKey(t),
                    child: _scene(
                      _frozen.putIfAbsent(t, () => AlwaysStoppedAnimation(t)),
                      clock,
                      layout,
                      geometry,
                      reduced,
                    ),
                  ),
                ),
              )
            : _scene(_timeline.controller, clock, layout, geometry, reduced);

        final content = Stack(
          fit: StackFit.expand,
          children: [scene, _chrome(time, layout)],
        );

        return ValueListenableBuilder<bool>(
          valueListenable: _statusDark,
          builder: (context, dark, child) =>
              AnnotatedRegion<SystemUiOverlayStyle>(
                value:
                    dark || (reduced && _reducedBeat == OnboardingBeat.landfall)
                    ? SystemUiOverlayStyle.dark
                    : SystemUiOverlayStyle.light,
                child: child!,
              ),
          child: Material(
            type: MaterialType.transparency,
            child: AbsorbPointer(
              absorbing: _exiting,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTap,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: AnimatedBuilder(
                  animation: _exit,
                  builder: (context, child) => _reveal(child!, size),
                  child: content,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// All story layers for one timeline source. Built once per layout; the
  /// painters and beat widgets listen to [time] themselves.
  Widget _scene(
    ValueListenable<double> time,
    AmbientClock clock,
    StageLayout layout,
    IslandGeometry geometry,
    bool reduced,
  ) {
    final ValueListenable<double> ambient = reduced
        ? const AlwaysStoppedAnimation(0.0)
        : clock;
    final ctaKey = _ctaKeys.putIfAbsent(time, GlobalKey.new);
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: CustomPaint(
            painter: AuroraPainter(
              time: time,
              clock: ambient,
              parallax: _parallax,
            ),
            foregroundPainter: reduced
                ? null
                : SprayParticlesPainter(
                    time: time,
                    clock: ambient,
                    parallax: _parallax,
                    count: _particleCount,
                    geometry: geometry,
                  ),
          ),
        ),
        RepaintBoundary(
          child: CustomPaint(
            painter: CoastlinePainter(
              time: time,
              parallax: _parallax,
              geometry: geometry,
            ),
            foregroundPainter: ChartMarksPainter(
              time: time,
              clock: ambient,
              parallax: _parallax,
              geometry: geometry,
            ),
            child: reduced
                ? null
                : CustomPaint(
                    painter: BeamPainter(
                      time: time,
                      parallax: _parallax,
                      geometry: geometry,
                    ),
                  ),
          ),
        ),
        RepaintBoundary(
          child: CustomPaint(
            painter: _ScrimPainter(time, layout.stage.bottom - 24),
          ),
        ),
        ReadBeat(time: time, parallax: _parallax, geometry: geometry),
        ExploreBeat(time: time, parallax: _parallax, geometry: geometry),
        CareBeat(
          time: time,
          clock: ambient,
          parallax: _parallax,
          geometry: geometry,
        ),
        CopyLayer(time: time, layout: layout),
        LandfallBeat(
          time: time,
          clock: ambient,
          buttonKey: ctaKey,
          onStart: () => _start(ctaKey),
          reducedMotion: reduced,
        ),
      ],
    );
  }

  /// Progress ticks and Skip — fixed, never part of the camera's world.
  Widget _chrome(ValueListenable<double> time, StageLayout layout) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.xs,
            AppSpace.sm,
            0,
          ),
          child: Row(
            children: [
              BeatProgress(time: time),
              const Spacer(),
              ValueListenableBuilder<double>(
                valueListenable: time,
                builder: (context, t, _) {
                  final paper = segOf(t, OnboardingTiming.paper);
                  // Hands over to the landfall button as it arrives.
                  final hide = segOf(t, OnboardingTiming.ctaRise);
                  final color = Color.lerp(
                    OnboardingColors.foam,
                    AppColors.depth,
                    paper,
                  )!;
                  return IgnorePointer(
                    ignoring: hide > 0.5,
                    child: ExcludeSemantics(
                      excluding: hide > 0.5,
                      child: Opacity(
                        opacity: 1 - hide,
                        child: TextButton(
                          key: _skipKey,
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            _start(_skipKey);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: color,
                            minimumSize: const Size(64, 44),
                          ),
                          child: Text(
                            'Skip',
                            semanticsLabel: 'Skip introduction',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The exit: a circle opening from the pressed control, with a beacon
  /// rim, while the story pushes slightly toward the viewer.
  Widget _reveal(Widget content, Size size) {
    final v = _exit.value;
    final center = _revealCenter;
    if (v == 0 || center == null) return content;
    final eased = Curves.easeInCubic.transform(v);
    final reach = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((c) => (c - center).distance).reduce(math.max);
    final radius = reach * eased;
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: _HoleClipper(center, radius),
          child: Transform.scale(
            scale: 1 + 0.06 * eased,
            alignment: Alignment(
              center.dx / size.width * 2 - 1,
              center.dy / size.height * 2 - 1,
            ),
            child: content,
          ),
        ),
        IgnorePointer(
          child: CustomPaint(painter: _RimPainter(center, radius, 1 - v)),
        ),
      ],
    );
  }
}

/// Darkens the lower screen behind the copy so it holds 4.5:1 over any
/// aurora frame; lifts away as the paper arrives.
class _ScrimPainter extends CustomPainter {
  _ScrimPainter(this.time, this.top) : super(repaint: time);

  final ValueListenable<double> time;
  final double top;
  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final strength = 1 - segOf(time.value, OnboardingTiming.dawn);
    if (strength <= 0) return;
    final rect = Rect.fromLTRB(0, top, size.width, size.height);
    _paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        OnboardingColors.night.withValues(alpha: 0),
        OnboardingColors.scrim.withValues(alpha: 0.8 * strength),
      ],
      stops: const [0, 0.45],
    ).createShader(rect);
    canvas.drawRect(rect, _paint);
  }

  @override
  bool shouldRepaint(_ScrimPainter old) => old.top != top || old.time != time;
}

class _HoleClipper extends CustomClipper<Path> {
  _HoleClipper(this.center, this.radius);

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) => Path()
    ..fillType = PathFillType.evenOdd
    ..addRect(Offset.zero & size)
    ..addOval(Rect.fromCircle(center: center, radius: radius));

  @override
  bool shouldReclip(_HoleClipper old) =>
      old.center != center || old.radius != radius;
}

class _RimPainter extends CustomPainter {
  _RimPainter(this.center, this.radius, this.alpha);

  final Offset center;
  final double radius;
  final double alpha;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius <= 0 || alpha <= 0) return;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.beacon.withValues(alpha: 0.8 * alpha),
    );
  }

  @override
  bool shouldRepaint(_RimPainter old) =>
      old.radius != radius || old.alpha != alpha;
}
