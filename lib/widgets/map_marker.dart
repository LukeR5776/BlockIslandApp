import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';

/// The chart symbol for a lighted aid: beacon core, white ring, beacon rim.
/// Visual only — the 44x44 hit area and tap handling belong to the caller.
class MapMarker extends StatelessWidget {
  final bool selected;
  final bool completed;

  const MapMarker({
    super.key,
    this.selected = false,
    this.completed = false,
  });

  static const _core = 14.0;
  static const _ring = _core + 3 * 2;
  static const _rim = _ring + 1 * 2;

  static const _beacon = BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.beacon,
  );

  static const _white = BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.surface,
  );

  Widget? get _completionDot => completed
      ? const Center(
          child: SizedBox(
            width: AppSpace.xs,
            height: AppSpace.xs,
            child: DecoratedBox(decoration: _white),
          ),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: Container(
        width: _rim,
        height: _rim,
        decoration: _beacon,
        child: Center(
          child: Container(
            width: _ring,
            height: _ring,
            decoration: _white,
            child: Center(
              child: Container(
                width: _core,
                height: _core,
                decoration: _beacon,
                child: _completionDot,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
