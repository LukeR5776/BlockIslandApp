import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/conservation_action.dart';
import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/section_header.dart';

/// Detail for one conservation action: description, steps, commit toggle,
/// and an optional external link.
class ActionScreen extends StatelessWidget {
  final ConservationAction action;

  const ActionScreen({super.key, required this.action});

  static Route<void> route(ConservationAction action) =>
      MaterialPageRoute<void>(builder: (_) => ActionScreen(action: action));

  static const _linkError =
      "Couldn't open that link. Try again with a connection.";

  @override
  Widget build(BuildContext context) {
    final committed = context.watch<AppState>().isActionCommitted(action.id);
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
            Text(action.title, style: AppText.title),
            const SizedBox(height: AppSpace.lg),
            ..._description(),
            if (action.steps.isNotEmpty) ..._steps(),
            const SizedBox(height: AppSpace.xl),
            _commitButton(context, committed),
            if (action.url != null) ...[
              const SizedBox(height: AppSpace.md),
              SecondaryButton(
                label: 'Visit website',
                onPressed: () => _openLink(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Split on double newline so paragraphs get proper spacing.
  List<Widget> _description() => [
    for (final (i, paragraph) in action.description.split('\n\n').indexed) ...[
      if (i > 0) const SizedBox(height: AppSpace.md),
      Text(paragraph, style: AppText.body),
    ],
  ];

  List<Widget> _steps() => [
    const SizedBox(height: AppSpace.lg),
    const SectionHeader(title: 'Steps'),
    for (final (i, step) in action.steps.indexed) ...[
      const SizedBox(height: AppSpace.md),
      _Step(number: i + 1, text: step),
    ],
  ];

  Widget _commitButton(BuildContext context, bool committed) {
    void toggle() => context.read<AppState>().toggleAction(action.id);
    return committed
        ? SecondaryButton(label: 'Committed', onPressed: toggle)
        : PrimaryButton(label: 'Commit to this', onPressed: toggle);
  }

  // launchUrl returns false or throws when there is no handler or no
  // connection; both get the same SnackBar.
  Future<void> _openLink(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(action.url!),
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(const SnackBar(content: Text(_linkError)));
    }
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('$number', style: AppText.data),
        const SizedBox(width: AppSpace.md),
        Expanded(child: Text(text, style: AppText.body)),
      ],
    );
  }
}
