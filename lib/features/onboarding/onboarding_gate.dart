import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'onboarding_overlay.dart';

/// Debug-only switches, read from `--dart-define`. All are ignored in
/// profile and release builds.
///
/// * `ONBOARDING=always` — show the sequence on every launch.
/// * `ONBOARDING_AT=<ms>` — hold the timeline at one moment (screenshots).
/// * `ONBOARDING_REDUCED=true` — force the reduce-motion version.
class OnboardingDebug {
  static bool get forceShow =>
      kDebugMode && const String.fromEnvironment('ONBOARDING') == 'always';

  static double? get freezeAt {
    const at = int.fromEnvironment('ONBOARDING_AT', defaultValue: -1);
    return kDebugMode && at >= 0 ? at.toDouble() : null;
  }

  static bool get forceReduced =>
      kDebugMode && const bool.fromEnvironment('ONBOARDING_REDUCED');
}

/// Shows the onboarding above [child] until it has been seen once.
///
/// The app underneath is built from the first frame, so the exit reveal
/// opens onto the real, already-laid-out home screen rather than pushing a
/// route.
class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key, required this.child});

  final Widget child;

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  // Lets a forced debug replay be dismissed for the rest of the session.
  bool _dismissed = false;

  void _finish() {
    setState(() => _dismissed = true);
    context.read<AppState>().markOnboardingSeen();
  }

  @override
  Widget build(BuildContext context) {
    final seen = context.select<AppState, bool>((s) => s.hasSeenOnboarding);
    // resetOnboarding() flips `seen` back, which replays it.
    final show = !seen || (OnboardingDebug.forceShow && !_dismissed);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hidden from VoiceOver while the overlay covers it.
        ExcludeSemantics(excluding: show, child: widget.child),
        if (show)
          // The sequence is set in large display type already; past this,
          // headlines would push the art off small screens.
          MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: OnboardingOverlay(
              onFinished: _finish,
              freezeAt: OnboardingDebug.freezeAt,
              forceReducedMotion: OnboardingDebug.forceReduced,
            ),
          ),
      ],
    );
  }
}
