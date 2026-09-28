import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Read-only until 3.4 adds completion, haptics, and the fill transition.
class QuestTile extends StatelessWidget {
  final Quest quest;

  const QuestTile({super.key, required this.quest});

  static const _circleSize = 22.0;

  // Completed state (filled beacon + check) lands in 3.4, not built yet.
  static const _incompleteCircle = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.fromBorderSide(BorderSide(color: AppColors.hairline)),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: _circleSize,
          height: _circleSize,
          child: DecoratedBox(decoration: _incompleteCircle),
        ),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quest.title, style: AppText.bodyStrong),
              Text(quest.prompt, style: AppText.caption),
            ],
          ),
        ),
      ],
    );
  }
}
