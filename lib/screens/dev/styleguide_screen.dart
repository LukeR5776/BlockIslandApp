import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class StyleguideScreen extends StatelessWidget {
  const StyleguideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Styleguide', style: AppText.display),
              const SizedBox(height: AppSpace.lg),

              // Colors
              const Text('Colors', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              const Text('Ground', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('paper', AppColors.paper, '0xFFFDFDFB'),
              _colorSwatch('surface', AppColors.surface, '0xFFFFFFFF'),
              _colorSwatch('hairline', AppColors.hairline, '0xFFCBD6DC'),
              const SizedBox(height: AppSpace.md),

              const Text('Chart tints', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('shoal', AppColors.shoal, '0xFFE3EDF2'),
              _colorSwatch('land', AppColors.land, '0xFFF0E8D8'),
              const SizedBox(height: AppSpace.md),

              const Text('Ink', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('ink', AppColors.ink, '0xFF16212B'),
              _colorSwatch('inkMuted', AppColors.inkMuted, '0xFF5E7280'),
              const SizedBox(height: AppSpace.md),

              const Text('Primary interactive', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('depth', AppColors.depth, '0xFF1D4A66'),
              const SizedBox(height: AppSpace.md),

              const Text('Accent', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('beacon', AppColors.beacon, '0xFFB12C7D'),
              const SizedBox(height: AppSpace.md),

              const Text('Supporting', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('kelp', AppColors.kelp, '0xFF4A6B4F'),
              _colorSwatch('hazard', AppColors.hazard, '0xFFA8431F'),
              const SizedBox(height: AppSpace.md),

              const Text('POI categories', style: AppText.caption),
              const SizedBox(height: AppSpace.sm),
              _colorSwatch('catShore', AppColors.catShore, '0xFF2E7191'),
              _colorSwatch('catTrail', AppColors.catTrail, '0xFF4A6B4F'),
              _colorSwatch('catHistoric', AppColors.catHistoric, '0xFF7A5C3E'),
              _colorSwatch('catWildlife', AppColors.catWildlife, '0xFF6B7F3F'),
              _colorSwatch('catTown', AppColors.catTown, '0xFF8C4B3A'),
              const SizedBox(height: AppSpace.lg),

              // Typography
              const Text('Typography', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              _typeSample('display', AppText.display, 'Mohegan Bluffs'),
              _typeSample('title', AppText.title, 'North Light'),
              _typeSample('heading', AppText.heading, 'Southeast Light'),
              _typeSample('body', AppText.body, 'The island rises from glacial moraine deposited during the last ice age.'),
              _typeSample('bodyStrong', AppText.bodyStrong, 'Clay Head Trail'),
              _typeSample('caption', AppText.caption, 'Recommended visit time: 45 minutes'),
              _typeSample('label', AppText.label, 'Historic'),
              _typeSample('data', AppText.data, '14 of 14'),
              const SizedBox(height: AppSpace.lg),

              // Spacing
              const Text('Spacing', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              _spacingBar('xs', AppSpace.xs),
              _spacingBar('sm', AppSpace.sm),
              _spacingBar('md', AppSpace.md),
              _spacingBar('lg', AppSpace.lg),
              _spacingBar('xl', AppSpace.xl),
              _spacingBar('xxl', AppSpace.xxl),
              const SizedBox(height: AppSpace.lg),

              // Radius
              const Text('Radius', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              Row(
                children: [
                  _radiusSample('sm', AppRadius.sm),
                  const SizedBox(width: AppSpace.md),
                  _radiusSample('md', AppRadius.md),
                  const SizedBox(width: AppSpace.md),
                  _radiusSample('lg', AppRadius.lg),
                  const SizedBox(width: AppSpace.md),
                  _radiusSample('full', AppRadius.full),
                ],
              ),
              const SizedBox(height: AppSpace.lg),

              // Border and shadow
              const Text('Border & shadow', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hairline border', style: AppText.caption),
                        const SizedBox(height: AppSpace.sm),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(
                              color: AppColors.hairline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sheet shadow', style: AppText.caption),
                        const SizedBox(height: AppSpace.sm),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.sheetShadow,
                                blurRadius: 24,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),

              // Buttons
              const Text('Buttons', style: AppText.heading),
              const SizedBox(height: AppSpace.md),

              PrimaryButton(
                label: 'Primary button',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpace.md),
              SecondaryButton(
                label: 'Secondary button',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpace.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorSwatch(String name, Color color, String hex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: AppColors.hairline, width: 1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.bodyStrong),
                Text(hex, style: AppText.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeSample(String name, TextStyle style, String sample) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppText.caption),
          const SizedBox(height: AppSpace.xs),
          Text(sample, style: style),
        ],
      ),
    );
  }

  Widget _spacingBar(String name, double size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(name, style: AppText.caption),
          ),
          Container(
            width: size,
            height: 24,
            color: AppColors.beacon,
          ),
          const SizedBox(width: AppSpace.sm),
          Text('${size.toInt()}pt', style: AppText.caption),
        ],
      ),
    );
  }

  Widget _radiusSample(String name, double radius) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.shoal,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.hairline, width: 1),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        Text(name, style: AppText.caption),
      ],
    );
  }
}
