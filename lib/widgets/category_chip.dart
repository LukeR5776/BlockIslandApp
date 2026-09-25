import 'package:flutter/material.dart';

import '../models/poi.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class CategoryChip extends StatelessWidget {
  final PoiCategory category;

  const CategoryChip({super.key, required this.category});

  /// Also the spoken category in map marker semantics, so the wording has one
  /// source.
  static String labelFor(PoiCategory category) => switch (category) {
        PoiCategory.shore => 'Shore',
        PoiCategory.trail => 'Trail',
        PoiCategory.historic => 'Historic',
        PoiCategory.landmark => 'Landmark',
        PoiCategory.organization => 'Organization',
      };

  Color get _color => switch (category) {
        PoiCategory.shore => AppColors.catShore,
        PoiCategory.trail => AppColors.catTrail,
        PoiCategory.historic => AppColors.catHistoric,
        PoiCategory.landmark => AppColors.catLandmark,
        PoiCategory.organization => AppColors.catOrganization,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sm,
        vertical: AppSpace.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        labelFor(category),
        style: AppText.label.copyWith(color: _color),
      ),
    );
  }
}
