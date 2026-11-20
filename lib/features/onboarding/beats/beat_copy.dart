import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../data/pois.dart';
import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../island_outline.dart';
import '../onboarding_timeline.dart';
import '../stage.dart';
import '../widgets/kinetic_headline.dart';

/// What each beat says. Copy describes what the app does — never a fact
/// about the island — and every number comes from lib/data at runtime.
class BeatCopy {
  final String headline;
  final String subtitle;

  /// A Plex Mono line typed on under the headline (hero only).
  final String? kicker;

  /// Hero-sized type (hero and landfall).
  final bool display;

  const BeatCopy(
    this.headline,
    this.subtitle, {
    this.kicker,
    this.display = false,
  });

  static BeatCopy of(OnboardingBeat beat) => switch (beat) {
    OnboardingBeat.hero => BeatCopy(
      'Block Island',
      'A guide to the island, and how to look after it.',
      kicker: _coordinates,
      display: true,
    ),
    OnboardingBeat.read => const BeatCopy(
      'Learn the island first',
      'Short reads on its ecology, history, geology and community.',
    ),
    OnboardingBeat.explore => BeatCopy(
      'Find it on the map',
      '${kPois.length} places, on a map that works offline.',
    ),
    OnboardingBeat.care => const BeatCopy(
      'Look after what you visit',
      'The island’s organizations, and how to help them.',
    ),
    OnboardingBeat.landfall => const BeatCopy(
      'Block Island',
      'Read it, explore it, look after it.',
      display: true,
    ),
  };

  /// The center of the coastline's bounding box, so the label always
  /// matches the outline being drawn.
  static final String _coordinates = () {
    var minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
    for (final (lat, lng) in kIslandOutline) {
      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLng = math.min(minLng, lng);
      maxLng = math.max(maxLng, lng);
    }
    final lat = (minLat + maxLat) / 2;
    final lng = (minLng + maxLng) / 2;
    return '${lat.abs().toStringAsFixed(2)}° N   '
        '${lng.abs().toStringAsFixed(2)}° W';
  }();
}

/// The narrative text block. One headline at a time sits in a fixed spot
/// low on the screen; each beat's letters leave upward just before the
/// next beat's rise in, so the copy reads as one continuous line of motion.
class CopyLayer extends StatelessWidget {
  const CopyLayer({super.key, required this.time, required this.layout});

  final ValueListenable<double> time;
  final StageLayout layout;

  static double _enterAt(OnboardingBeat beat) => switch (beat) {
    OnboardingBeat.hero => OnboardingTiming.heroTitleIn,
    OnboardingBeat.landfall => OnboardingTiming.landfallTitleIn,
    _ => beatStart(beat) + OnboardingTiming.copyIn,
  };

  static double _leaveAt(OnboardingBeat beat) => beat == OnboardingBeat.landfall
      ? double.infinity
      : beatEnd(beat) - OnboardingTiming.copyOut;

  @override
  Widget build(BuildContext context) {
    final width = layout.size.width;
    return Positioned(
      left: layout.padding.left + 24,
      right: layout.padding.right + 24,
      bottom: layout.copyBottom,
      child: ValueListenableBuilder<double>(
        valueListenable: time,
        builder: (context, t, _) {
          final beat = beatAt(t);
          final copy = BeatCopy.of(beat);
          final enter = t - _enterAt(beat);
          final leave = t - _leaveAt(beat);
          final paper = segOf(t, OnboardingTiming.paper, Curves.easeInOut);
          final ink = Color.lerp(OnboardingColors.foam, AppColors.ink, paper)!;
          final muted = Color.lerp(
            OnboardingColors.foamMuted,
            AppColors.inkMuted,
            paper,
          )!;

          final headlineStyle = copy.display
              ? TextStyle(
                  fontSize: (width * 0.15).clamp(44.0, 64.0),
                  fontWeight: FontWeight.w600,
                  height: 1.08,
                  letterSpacing: -1.4,
                  color: ink,
                )
              : TextStyle(
                  fontSize: (width * 0.085).clamp(28.0, 38.0),
                  fontWeight: FontWeight.w600,
                  height: 1.14,
                  letterSpacing: -0.6,
                  color: ink,
                );

          return Semantics(
            // Keyed by beat so VoiceOver announces each new headline once.
            key: ValueKey(beat),
            container: true,
            liveRegion: true,
            label: '${copy.headline}. ${copy.subtitle}',
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  KineticHeadline(
                    text: copy.headline,
                    style: headlineStyle,
                    enter: enter,
                    leave: leave,
                  ),
                  if (copy.kicker case final kicker?) ...[
                    const SizedBox(height: 10),
                    _TypeOn(
                      text: kicker,
                      progress: segOf(t, OnboardingTiming.coordsTypeOn),
                      leave: leave,
                      color: OnboardingColors.seaGlass,
                    ),
                  ],
                  const SizedBox(height: 12),
                  MaskedLine(
                    text: copy.subtitle,
                    style: TextStyle(
                      fontSize: 16.5,
                      height: 1.45,
                      color: muted,
                    ),
                    enter: enter - (copy.display ? 900 : 260),
                    leave: leave,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Mono text typed on character by character, with a beacon caret that
/// disappears when it finishes.
class _TypeOn extends StatelessWidget {
  const _TypeOn({
    required this.text,
    required this.progress,
    required this.leave,
    required this.color,
  });

  final String text;
  final double progress;
  final double leave;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final shown = (text.length * progress).round();
    final out = 1 - seg(leave, 0, 300);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text.substring(0, shown),
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: color.withValues(alpha: out),
          ),
        ),
        if (progress > 0 && progress < 1)
          Container(
            width: 7,
            height: 14,
            margin: const EdgeInsets.only(left: 2),
            color: OnboardingColors.beacon,
          ),
      ],
    );
  }
}
