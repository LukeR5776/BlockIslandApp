import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/poi.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import 'category_chip.dart';

/// Hairline-bordered tappable card used by every list in the app.
class ContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final PoiCategory? category;
  final String? imageAsset;
  final bool checked;
  final VoidCallback onTap;

  const ContentCard({
    super.key,
    required this.title,
    this.subtitle,
    this.category,
    this.imageAsset,
    this.checked = false,
    required this.onTap,
  });

  static final _radius = BorderRadius.circular(AppRadius.md);

  // Border painted in the foreground so a cover photo can't cover the
  // hairline; fill and photo are clipped to the same radius underneath.
  static final _border = BoxDecoration(
    border: Border.all(color: AppColors.hairline, width: 1),
    borderRadius: _radius,
  );

  static const _coverAspectRatio = 16 / 9;

  // Many POIs have no photo yet. The cover takes space only once a frame
  // decodes, and a missing asset collapses it, so those cards read as
  // text-only rather than showing an empty block.
  static Widget _frame(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) => frame == null
      ? const SizedBox.shrink()
      : AspectRatio(aspectRatio: _coverAspectRatio, child: child);

  static Widget _missing(BuildContext context, Object error, StackTrace? st) =>
      const SizedBox.shrink();

  void _handleTap() {
    HapticFeedback.selectionClick();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: DecoratedBox(
          decoration: _border,
          position: DecorationPosition.foreground,
          child: ClipRRect(
            borderRadius: _radius,
            child: ColoredBox(
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (imageAsset case final asset?) _cover(asset),
                  _body(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Decorative: the title below already names the place for VoiceOver.
  Widget _cover(String asset) => Image.asset(
    asset,
    fit: BoxFit.cover,
    excludeFromSemantics: true,
    frameBuilder: _frame,
    errorBuilder: _missing,
  );

  Widget _body() => Padding(
    padding: const EdgeInsets.all(AppSpace.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _text()),
        if (checked) ...[
          const SizedBox(width: AppSpace.sm),
          const Icon(
            Icons.check,
            color: AppColors.beacon,
            semanticLabel: 'Completed',
          ),
        ],
      ],
    ),
  );

  Widget _text() {
    final category = this.category;
    final subtitle = this.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category != null) ...[
          CategoryChip(category: category),
          const SizedBox(height: AppSpace.sm),
        ],
        Text(title, style: AppText.heading),
        if (subtitle != null) Text(subtitle, style: AppText.caption),
      ],
    );
  }
}
