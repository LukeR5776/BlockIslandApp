import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app_shell.dart';
import '../../../theme/onboarding_tokens.dart';
import '../../../theme/spacing.dart';
import '../onboarding_timeline.dart';
import '../widgets/shimmer_button.dart';

/// Beat 5: the payoff. The app's real nav bar rises into exactly the place
/// it occupies in the app, then the button. When the button is pressed the
/// overlay opens a hole onto the real app underneath, so the replica bar
/// hands off to the real one without a visible seam.
class LandfallBeat extends StatelessWidget {
  const LandfallBeat({
    super.key,
    required this.time,
    required this.clock,
    required this.buttonKey,
    required this.onStart,
    required this.reducedMotion,
  });

  final ValueListenable<double> time;
  final ValueListenable<double> clock;

  /// Lets the overlay find the button's center for the exit reveal.
  final GlobalKey buttonKey;
  final VoidCallback onStart;
  final bool reducedMotion;

  static const label = 'Come ashore';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder<double>(
        valueListenable: time,
        builder: (context, t, _) {
          final nav = segOf(
            t,
            OnboardingTiming.navRise,
            OnboardingCurves.enter,
          );
          final cta = segOf(t, OnboardingTiming.ctaRise, OnboardingCurves.land);
          final ctaAlpha = (segOf(t, OnboardingTiming.ctaRise) * 2.5).clamp(
            0.0,
            1.0,
          );
          final live = ctaAlpha > 0.5;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
                child: Transform.translate(
                  offset: Offset(0, (1 - cta) * 28),
                  child: Opacity(
                    opacity: ctaAlpha,
                    child: ExcludeSemantics(
                      excluding: !live,
                      child: ShimmerButton(
                        key: buttonKey,
                        label: label,
                        clock: clock,
                        animate: !reducedMotion,
                        onPressed: live ? onStart : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              // Decorative replica: the real bar is right underneath.
              ExcludeSemantics(
                child: IgnorePointer(
                  child: FractionalTranslation(
                    translation: Offset(0, 1 - nav),
                    child: AppNavBar(selectedIndex: 0, onSelect: (_) {}),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
