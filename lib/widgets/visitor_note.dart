import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Practical caution callout (land fill, hazard left strip). Not an alarm.
class VisitorNote extends StatelessWidget {
  final String text;

  const VisitorNote({super.key, required this.text});

  /// Flutter asserts when a borderRadius is combined with a one-sided border,
  /// so the rounding comes from the clip instead of the decoration.
  static const _decoration = BoxDecoration(
    color: AppColors.land,
    border: Border(left: BorderSide(color: AppColors.hazard, width: 3)),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: _decoration,
        child: Text(text, style: AppText.caption.copyWith(color: AppColors.ink)),
      ),
    );
  }
}
