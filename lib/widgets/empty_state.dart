import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/typography.dart';

/// One sentence saying what goes here. No illustration, no apology.
class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Text(message, style: AppText.body, textAlign: TextAlign.center),
      ),
    );
  }
}
