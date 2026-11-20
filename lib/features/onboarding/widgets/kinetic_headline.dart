import 'package:flutter/widgets.dart';

import '../../../theme/onboarding_tokens.dart';
import '../onboarding_timeline.dart';

/// A headline whose letters rise one by one out of a mask, and leave
/// upward through it.
///
/// Driven by two clocks in ms: [enter] (time since the entrance began) and
/// [leave] (time since the exit began; negative until then). Being a pure
/// function of time, it scrubs backwards for free.
///
/// Letter alpha is baked into the text color rather than wrapped in
/// `Opacity`, so a 20-letter headline costs no offscreen layers.
class KineticHeadline extends StatelessWidget {
  const KineticHeadline({
    super.key,
    required this.text,
    required this.style,
    required this.enter,
    required this.leave,
    this.stagger = OnboardingTiming.letterStagger,
  });

  final String text;
  final TextStyle style;
  final double enter;
  final double leave;
  final double stagger;

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitted = _fit(words, scaler, constraints.maxWidth);
        var index = 0;
        return Wrap(
          spacing: (fitted.fontSize ?? 16) * 0.28,
          children: [
            for (final word in words)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final letter in word.characters)
                    _letter(letter, index++, fitted),
                ],
              ),
          ],
        );
      },
    );
  }

  // Keyed by everything that changes a measurement. Builds run every frame
  // while letters move, so each headline is measured once, not 60× a second.
  static final _fitCache = <String, double>{};

  /// Shrinks the type just enough that the longest word fits on one line —
  /// words never break mid-letter-row, so a long word at a large text size
  /// would otherwise overflow.
  TextStyle _fit(List<String> words, TextScaler scaler, double maxWidth) {
    final size = style.fontSize ?? 16;
    if (!maxWidth.isFinite) return style;
    final key =
        '$text|$size|${style.letterSpacing}|${scaler.scale(size)}|'
        '$maxWidth';
    final scale = _fitCache.putIfAbsent(key, () {
      var widest = 0.0;
      for (final word in words) {
        // Letters are laid out as separate Texts, so measure them that way.
        var width = 0.0;
        for (final letter in word.characters) {
          final painter = TextPainter(
            text: TextSpan(text: letter, style: style),
            textDirection: TextDirection.ltr,
            textScaler: scaler,
          )..layout();
          width += painter.width;
          painter.dispose();
        }
        if (width > widest) widest = width;
      }
      return widest > maxWidth ? maxWidth / widest * 0.98 : 1.0;
    });
    return scale == 1.0 ? style : style.copyWith(fontSize: size * scale);
  }

  Widget _letter(String letter, int i, TextStyle style) {
    final p = seg(
      enter,
      i * stagger,
      i * stagger + OnboardingTiming.letterLength,
      OnboardingCurves.letter,
    );
    // Exits ripple faster than entrances: leaving should not linger.
    final o = seg(
      leave,
      i * stagger * 0.4,
      i * stagger * 0.4 + 420,
      OnboardingCurves.exit,
    );
    final color = style.color ?? const Color(0xFFFFFFFF);
    final alpha = (p * 1.8).clamp(0.0, 1.0) * (1 - o);
    return ClipRect(
      child: FractionalTranslation(
        translation: Offset(0, (1 - p) * 1.05 - o * 1.05),
        child: Text(
          letter,
          style: style.copyWith(
            color: color.withValues(alpha: color.a * alpha),
          ),
        ),
      ),
    );
  }
}

/// A line (or short paragraph) that slides up out of a mask and fades — the
/// quieter partner to [KineticHeadline].
class MaskedLine extends StatelessWidget {
  const MaskedLine({
    super.key,
    required this.text,
    required this.style,
    required this.enter,
    required this.leave,
    this.length = 650,
  });

  final String text;
  final TextStyle style;
  final double enter;
  final double leave;
  final double length;

  @override
  Widget build(BuildContext context) {
    final p = seg(enter, 0, length, OnboardingCurves.enter);
    final o = seg(leave, 0, 320, OnboardingCurves.exit);
    final color = style.color ?? const Color(0xFFFFFFFF);
    return ClipRect(
      child: FractionalTranslation(
        translation: Offset(0, (1 - p) * 0.7 - o * 0.4),
        child: Text(
          text,
          style: style.copyWith(
            color: color.withValues(alpha: color.a * p * (1 - o)),
          ),
        ),
      ),
    );
  }
}
