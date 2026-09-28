import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Heading + optional trailing count, hairline rule below. No uppercase eyebrow.
class SectionHeader extends StatelessWidget {
  final String title;
  final int? count;

  const SectionHeader({super.key, required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    final count = this.count;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(title, style: AppText.heading)),
            if (count != null)
              Text(
                '$count',
                style: AppText.data.copyWith(color: AppColors.inkMuted),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.sm),
        const Divider(height: 1, thickness: 1, color: AppColors.hairline),
      ],
    );
  }
}
