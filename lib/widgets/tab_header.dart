import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';

/// The night-sea header that tops each tab, carrying the onboarding's look
/// into the app: deep gradient, a soft colored glow, display title.
class TabHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  /// Tints the glow, so each tab has its own color.
  final Color accent;
  final IconData icon;

  const TabHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.headerNight, AppColors.headerSea],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -60,
                top: -40,
                child: _Glow(color: accent, size: 260),
              ),
              Positioned(
                left: -80,
                bottom: -90,
                child: _Glow(color: AppColors.beacon, size: 220),
              ),
              Positioned(
                right: AppSpace.md,
                bottom: AppSpace.md,
                child: Icon(icon,
                    size: 72, color: Colors.white.withValues(alpha: 0.08)),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -0.8,
                          color: Color(0xFFEAF3F6),
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: Color(0xFFA9C0CC),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;

  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [
          color.withValues(alpha: 0.45),
          color.withValues(alpha: 0),
        ]),
      ),
    );
  }
}
