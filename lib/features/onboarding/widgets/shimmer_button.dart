import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';

/// The landfall call to action: PrimaryButton's depth fill and shape, with
/// a band of light sweeping across it and a slow beacon breath behind it.
///
/// Built on [ElevatedButton] so focus, keyboard activation and the button
/// semantics come from Material rather than being re-implemented.
class ShimmerButton extends StatefulWidget {
  const ShimmerButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.clock,
    this.animate = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final ValueListenable<double> clock;

  /// False under reduce motion: no sweep, no breath.
  final bool animate;

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.depth,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.depth,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          widget.label,
          style: AppText.bodyStrong.copyWith(color: Colors.white),
        ),
      ),
    );

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.965 : 1,
        duration: const Duration(milliseconds: 260),
        curve: _pressed ? Curves.easeOutCubic : OnboardingCurves.land,
        child: widget.animate
            ? CustomPaint(
                painter: _BreathPainter(widget.clock),
                foregroundPainter: _SweepPainter(widget.clock),
                child: button,
              )
            : button,
      ),
    );
  }
}

/// A soft beacon glow behind the button, breathing on a 2.4 s cycle.
class _BreathPainter extends CustomPainter {
  _BreathPainter(this.clock) : super(repaint: clock);

  final ValueListenable<double> clock;
  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final breath = 0.5 + 0.5 * math.sin(clock.value * 2 * math.pi / 2.4);
    final rect = (Offset.zero & size).inflate(4 + 6 * breath);
    _paint
      ..color = AppColors.beacon.withValues(alpha: 0.10 + 0.14 * breath)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + 6 * breath);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(AppRadius.md + 6)),
      _paint,
    );
  }

  @override
  bool shouldRepaint(_BreathPainter old) => old.clock != clock;
}

/// A diagonal band of light crossing the button every 2.8 s.
class _SweepPainter extends CustomPainter {
  _SweepPainter(this.clock) : super(repaint: clock);

  final ValueListenable<double> clock;
  final _paint = Paint();

  static const _period = 2.8;
  static const _travel = 0.55; // fraction of the period spent crossing

  @override
  void paint(Canvas canvas, Size size) {
    final phase = (clock.value % _period) / _period / _travel;
    if (phase >= 1) return;
    final band = size.height * 1.6;
    final x =
        -band + (size.width + band * 2) * Curves.easeInOutSine.transform(phase);
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(AppRadius.md)),
    );
    _paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.white.withValues(alpha: 0),
        Colors.white.withValues(alpha: 0.22),
        Colors.white.withValues(alpha: 0),
      ],
      transform: const GradientRotation(0.35),
    ).createShader(Rect.fromLTWH(x, 0, band, size.height));
    canvas.drawRect(rect, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SweepPainter old) => old.clock != clock;
}
