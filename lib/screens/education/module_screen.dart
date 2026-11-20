import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/primary_button.dart';

/// The module reader. Read-tracking is a manual button at the end rather
/// than scroll detection (PLAN.md cut line 3).
class ModuleScreen extends StatelessWidget {
  final Module module;

  const ModuleScreen({super.key, required this.module});

  /// Pushed from both the Education lists and PoiScreen.
  static Route<void> route(Module module) =>
      MaterialPageRoute<void>(builder: (_) => ModuleScreen(module: module));

  @override
  Widget build(BuildContext context) {
    final isRead = context.watch<AppState>().isModuleRead(module.id);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.md,
            AppSpace.sm,
            AppSpace.md,
            AppSpace.xl,
          ),
          children: [
            Text(module.title, style: AppText.title),
            const SizedBox(height: AppSpace.sm),
            Text('${module.readMinutes} min read', style: AppText.caption),
            const SizedBox(height: AppSpace.lg),
            Text(module.summary, style: AppText.bodyStrong),
            for (final section in module.sections) ..._section(section),
            const SizedBox(height: AppSpace.xl),
            if (isRead)
              const _ReadStatus()
            else
              PrimaryButton(
                label: 'Mark as read',
                onPressed: () => _markRead(context),
              ),
          ],
        ),
      ),
    );
  }

  void _markRead(BuildContext context) =>
      context.read<AppState>().markModuleRead(module.id);

  List<Widget> _section(ModuleSection section) {
    final image = section.imageAsset;
    return [
      const SizedBox(height: AppSpace.lg),
      Text(section.heading, style: AppText.heading),
      const SizedBox(height: AppSpace.sm),
      if (image != null) ...[
        _SectionImage(asset: image),
        const SizedBox(height: AppSpace.md),
      ],
      // Split on double newline so paragraphs get proper spacing.
      for (final (i, paragraph) in section.body.split('\n\n').indexed) ...[
        if (i > 0) const SizedBox(height: AppSpace.md),
        Text(paragraph, style: AppText.body),
      ],
    ];
  }
}

class _SectionImage extends StatelessWidget {
  final String asset;

  const _SectionImage({required this.asset});

  /// Photos may not be bundled yet; a tinted block keeps the layout intact
  /// instead of Flutter's error box.
  static Widget _fallback(BuildContext context, Object error, StackTrace? st) =>
      const ColoredBox(color: AppColors.land);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.asset(asset, fit: BoxFit.cover, errorBuilder: _fallback),
      ),
    );
  }
}

/// Replaces the button once read. AppState has no "unread", so there is
/// nothing to tap.
class _ReadStatus extends StatelessWidget {
  const _ReadStatus();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check, color: AppColors.beacon),
        SizedBox(width: AppSpace.sm),
        Text('Read', style: AppText.bodyStrong),
      ],
    );
  }
}
