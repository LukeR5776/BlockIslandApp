import 'dart:math' as math;

import 'package:flutter/animation.dart';

import 'colors.dart';

/// Tokens for the first-launch "Landfall" sequence. Every timing, color and
/// curve the onboarding uses lives here so the whole piece can be retimed or
/// recolored from one file — see docs/onboarding_design.md.

/// The five story beats, in order.
enum OnboardingBeat { hero, read, explore, care, landfall }

/// All times are milliseconds on one master timeline.
class OnboardingTiming {
  /// Where each beat starts. The next beat's start is this one's end.
  static const beatStart = <OnboardingBeat, double>{
    OnboardingBeat.hero: 0,
    OnboardingBeat.read: 3400,
    OnboardingBeat.explore: 6200,
    OnboardingBeat.care: 9200,
    OnboardingBeat.landfall: 11600,
  };

  /// Autoplay stops here and waits for the button.
  static const total = 14000.0;

  /// The frame each beat is "composed" at. Taps and swipes land here, and
  /// reduce-motion shows only these frames.
  ///
  /// Each must fall after its beat's last entrance finishes and before
  /// `beatEnd - copyOut`, when the copy starts leaving.
  static const settle = <OnboardingBeat, double>{
    OnboardingBeat.hero: 2950,
    OnboardingBeat.read: 5750,
    OnboardingBeat.explore: 8750,
    OnboardingBeat.care: 11150,
    OnboardingBeat.landfall: total,
  };

  /// Copy leaves this long before its beat ends, so the next headline
  /// replaces it rather than overlapping it.
  static const copyOut = 380.0;

  /// Copy enters this long after its beat starts.
  static const copyIn = 220.0;

  /// Hero holds its copy longer: the coastline has to draw first.
  static const heroTitleIn = 1150.0;

  // ── Hero ───────────────────────────────────────────────────────────────
  static const particleConvergeStart = 0.0;
  static const particleConvergeSpread = 1300.0; // stagger along the coast
  static const particleConvergeLength = 750.0; // each particle's flight
  /// Trails the particles by ~50 ms so the line appears to be laid down by
  /// them as they arrive.
  static const coastDraw = (800.0, 2150.0);
  static const coastFill = (1900.0, 2800.0);
  static const beamSweep = (250.0, 2900.0);
  static const letterStagger = 46.0;
  static const letterLength = 700.0;
  static const coordsTypeOn = (1950.0, 2650.0);
  static const titleLandHaptic = 1900.0;

  // ── Read ───────────────────────────────────────────────────────────────
  static const particleRelease = (3400.0, 4300.0);
  static const tileFlyStart = 3650.0;
  static const tileStagger = 95.0;
  static const tileFlyLength = 760.0;
  static const moduleCardRise = (4350.0, 5050.0);
  static const moduleLinesDraw = (4750.0, 5650.0);

  // ── Explore ────────────────────────────────────────────────────────────
  static const tileCollapse = (6200.0, 6650.0);
  static const markerDropStart = 6450.0;
  static const markerDropSpread = 950.0; // north → south cascade
  static const markerDropLength = 560.0;
  static const courseDraw = (7050.0, 8500.0);
  static const counterTick = (6700.0, 7950.0);
  static const sheetRise = (7600.0, 8250.0);

  // ── Care ───────────────────────────────────────────────────────────────
  static const sheetDrop = (9200.0, 9520.0);
  static const kelpTint = (9300.0, 10250.0);
  static const compassDraw = (9400.0, 10650.0);
  static const bloomStart = 9300.0;
  static const bloomSpread = 520.0;
  static const bloomLength = 950.0;
  static const orgFloatStart = 9750.0;
  static const orgStagger = 115.0;
  static const orgFloatLength = 720.0;

  // ── Landfall ───────────────────────────────────────────────────────────
  static const dawn = (11600.0, 12650.0);
  static const paper = (12200.0, 13050.0);
  static const chartColors = (12000.0, 12950.0);
  static const navRise = (12450.0, 13150.0);
  static const ctaRise = (12900.0, 13550.0);

  /// The title waits for the paper to arrive, so it is never mid-contrast.
  static const landfallTitleIn = 12450.0;

  // ── Camera moves: each beat's first stretch ─────────────────────────────
  static const cameraMove = 950.0;

  // ── Interaction ────────────────────────────────────────────────────────
  /// A full-width horizontal drag scrubs this much of the timeline.
  static const scrubPerScreen = 2800.0;
  static const exit = Duration(milliseconds: 950);

  /// Reduce motion: how long each composed frame holds before advancing,
  /// and the crossfade between them.
  static const reducedHold = Duration(milliseconds: 4200);
  static const reducedFade = Duration(milliseconds: 320);
}

/// The night-sea palette. Built from the app's chart palette — depth, shoal,
/// land, beacon, kelp — pushed darker so the island can glow out of it.
class OnboardingColors {
  static const night = Color(0xFF061019); // deepest water
  static const sea = Color(0xFF0C2537);
  static const swell = AppColors.depth;
  static const glow = Color(0xFF2E7191); // = catShore, lit water
  static const seaGlass = Color(0xFF6FB7A8);
  static const dawn = Color(0xFFF0A27A); // sunrise on the bluffs
  static const dawnHigh = Color(0xFFF6D6B8);

  /// Text and line work on the night background. foam on night is 16:1,
  /// foamMuted on night 8.7:1.
  static const foam = Color(0xFFEAF3F6);
  static const foamMuted = Color(0xFFA9C0CC);

  /// The island before dawn: a shade lighter than the sea around it.
  static const nightLand = Color(0xFF173A4F);

  static const beacon = AppColors.beacon;
  static const kelp = AppColors.kelp;
  static const kelpLight = Color(0xFF8DB596);

  /// Behind the copy so it stays readable over any aurora frame.
  static const scrim = Color(0xCC061019);
}

/// Curves. Nothing in the sequence runs linear except the type-on caret.
class OnboardingCurves {
  /// Camera: slow to leave, long settle — reads as a dolly, not a cut.
  static const camera = Cubic(0.65, 0.0, 0.2, 1.0);

  /// Material 3 "emphasized decelerate" — entrances.
  static const enter = Cubic(0.05, 0.7, 0.1, 1.0);

  /// Exits accelerate away.
  static const exit = Cubic(0.3, 0.0, 0.8, 0.15);

  /// Per-letter rise: fast out of the mask, soft landing.
  static const letter = Cubic(0.16, 1.0, 0.3, 1.0);

  /// Marker drops and card landings: a spring with one visible overshoot.
  static const land = SpringCurve(damping: 0.52);

  /// Org pills: looser, floatier spring.
  static const float = SpringCurve(damping: 0.42);

  static const smooth = Curves.easeInOutCubic;
}

/// An underdamped spring from 0 to 1 sampled as a [Curve], so springs can be
/// placed on the timeline (and scrubbed backwards) like any other interval.
/// [damping] is the damping ratio: lower bounces more.
class SpringCurve extends Curve {
  final double damping;

  const SpringCurve({this.damping = 0.5});

  // Natural frequency chosen so the envelope e^(-ζωt) has decayed to ~0.2%
  // by t = 1 — the spring is visually at rest when the interval ends.
  @override
  double transformInternal(double t) {
    final omega = 6.2 / damping;
    final dampedOmega = omega * math.sqrt(1 - damping * damping);
    final decay = math.exp(-damping * omega * t);
    return 1 -
        decay *
            (math.cos(dampedOmega * t) +
                (damping * omega / dampedOmega) * math.sin(dampedOmega * t));
  }
}

/// Particle budget. Scaled by screen area, then halved at runtime if frame
/// timings show the device is struggling.
class OnboardingParticles {
  static const perReferenceScreen = 220;
  static const referenceArea = 390.0 * 844.0;
  static const min = 70;
  static const max = 260;

  /// Median raster time (µs) over the sampling window that triggers the
  /// halving. 60 Hz leaves 16.7 ms; this keeps headroom.
  static const rasterBudgetMicros = 11000;
  static const sampleFrames = 45;
}
