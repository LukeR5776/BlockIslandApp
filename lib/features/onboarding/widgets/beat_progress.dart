import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/colors.dart';
import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';

/// Five short chart-scale ticks, one per beat. The current tick fills with
/// beacon as its beat plays; finished ones stay lit.
class BeatProgress extends StatelessWidget {
  const BeatProgress({super.key, required this.time});

  final ValueListenable<double> time;

  static const _tickWidth = 22.0;
  static const _gap = 6.0;
  static const _height = 3.0;
  static const _count = 5;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: time,
      // Only the label depends on the beat; the painter repaints from [time].
      builder: (context, t, child) => Semantics(
        label: 'Step ${beatAt(t).index + 1} of $_count',
        child: child,
      ),
      child: CustomPaint(
        size: const Size(_tickWidth * _count + _gap * (_count - 1), 44),
        painter: _TicksPainter(time),
      ),
    );
  }
}

class _TicksPainter extends CustomPainter {
  _TicksPainter(this.time) : super(repaint: time);

  final ValueListenable<double> time;
  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final paper = segOf(t, OnboardingTiming.paper);
    final track = Color.lerp(
      OnboardingColors.foam.withValues(alpha: 0.22),
      AppColors.hairline,
      paper,
    )!;
    final done = Color.lerp(OnboardingColors.foam, AppColors.depth, paper)!;
    final y = (size.height - BeatProgress._height) / 2;
    const radius = Radius.circular(BeatProgress._height / 2);

    for (final beat in OnboardingBeat.values) {
      final x = beat.index * (BeatProgress._tickWidth + BeatProgress._gap);
      final r = Rect.fromLTWH(
        x,
        y,
        BeatProgress._tickWidth,
        BeatProgress._height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, radius),
        _paint..color = track,
      );
      final fill = seg(t, beatStart(beat), beatEnd(beat));
      if (fill <= 0) continue;
      final current = beatAt(t) == beat && fill < 1;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            y,
            BeatProgress._tickWidth * fill,
            BeatProgress._height,
          ),
          radius,
        ),
        _paint..color = current ? OnboardingColors.beacon : done,
      );
    }
  }

  @override
  bool shouldRepaint(_TicksPainter old) => old.time != time;
}
