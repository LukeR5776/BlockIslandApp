import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// One segment of a [ViewToggle].
class ViewToggleOption<T> {
  final T value;
  final String label;

  const ViewToggleOption(this.value, this.label);
}

/// Small text switch for flipping a screen between views (e.g. Map | List).
/// Mirrors the bottom nav: depth for the active label, a short beacon bar
/// under it, hairline rule below the whole row, no shadow.
class ViewToggle<T> extends StatelessWidget {
  final List<ViewToggleOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const ViewToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  static const _decoration = BoxDecoration(
    color: AppColors.paper,
    border: Border(bottom: BorderSide(color: AppColors.hairline, width: 1)),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _Segment(
                label: option.label,
                selected: option.value == selected,
                onTap: () => onChanged(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _minTapHeight = 44.0;
  static const _indicatorWidth = AppSpace.lg;
  static const _indicatorHeight = 2.0;

  Color get _color => selected ? AppColors.depth : AppColors.inkMuted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minTapHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(label, style: AppText.label.copyWith(color: _color)),
              const SizedBox(height: AppSpace.sm),
              // Always laid out so the label doesn't shift; unpainted when
              // inactive so the hairline below stays unbroken.
              SizedBox(
                width: _indicatorWidth,
                height: _indicatorHeight,
                child: selected
                    ? const ColoredBox(color: AppColors.beacon)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
