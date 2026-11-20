import 'package:block_island/features/onboarding/onboarding_gate.dart';
import 'package:block_island/features/onboarding/onboarding_overlay.dart';
import 'package:block_island/state/app_state.dart';
import 'package:block_island/theme/app_theme.dart';
import 'package:block_island/theme/onboarding_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The gate over a stand-in home screen, at iPhone 16 Pro size. The real
/// AppShell is left out: its map tab loads tile assets that have nothing to
/// do with what is under test here.
Future<AppState> _pumpGate(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(prefs);
  final state = AppState();
  await state.load();

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: buildAppTheme(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduceMotion,
          ),
          child: child!,
        ),
        home: const OnboardingGate(
          child: Scaffold(body: Center(child: Text('Home screen'))),
        ),
      ),
    ),
  );
  return state;
}

/// Pumps in frame-sized steps. Never pumpAndSettle: the ambient drift and
/// the button shimmer loop forever by design.
Future<void> _advance(WidgetTester tester, Duration total) async {
  const frame = Duration(milliseconds: 16);
  for (var elapsed = Duration.zero; elapsed < total; elapsed += frame) {
    await tester.pump(frame);
  }
}

const _afterExit = Duration(milliseconds: 1200);

void main() {
  testWidgets('shows on first launch', (tester) async {
    await _pumpGate(tester);
    await _advance(tester, const Duration(milliseconds: 300));

    expect(find.byType(OnboardingOverlay), findsOneWidget);
    expect(find.bySemanticsLabel('Skip introduction'), findsOneWidget);
  });

  testWidgets('Skip dismisses it and persists the flag', (tester) async {
    final state = await _pumpGate(tester);
    await _advance(tester, const Duration(milliseconds: 500));

    await tester.tap(find.text('Skip'));
    await _advance(tester, _afterExit);

    expect(find.byType(OnboardingOverlay), findsNothing);
    expect(find.text('Home screen'), findsOneWidget);
    expect(state.hasSeenOnboarding, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('hasSeenOnboarding'), isTrue);
  });

  testWidgets('does not reappear once seen', (tester) async {
    await _pumpGate(tester, prefs: {'hasSeenOnboarding': true});
    await tester.pump();

    expect(find.byType(OnboardingOverlay), findsNothing);
    expect(find.text('Home screen'), findsOneWidget);
  });

  testWidgets('plays through every beat and ends on the button',
      (tester) async {
    final state = await _pumpGate(tester);
    final semantics = tester.ensureSemantics();

    await _advance(tester, const Duration(milliseconds: 4200));
    expect(find.bySemanticsLabel(RegExp('^Learn the island first')),
        findsOneWidget);

    await _advance(tester, const Duration(milliseconds: 3600));
    expect(find.bySemanticsLabel(RegExp('^Find it on the map')),
        findsOneWidget);

    await _advance(
      tester,
      Duration(milliseconds: OnboardingTiming.total.round() - 7800 + 300),
    );
    expect(find.text('Come ashore'), findsOneWidget);
    // Skip hands over to the button on the last beat.
    expect(find.text('Skip').hitTestable(), findsNothing);

    await tester.tap(find.text('Come ashore'));
    await _advance(tester, _afterExit);

    expect(find.byType(OnboardingOverlay), findsNothing);
    expect(state.hasSeenOnboarding, isTrue);
    semantics.dispose();
  });

  testWidgets('tapping the screen advances to the next beat', (tester) async {
    await _pumpGate(tester);
    final semantics = tester.ensureSemantics();
    await _advance(tester, const Duration(milliseconds: 3000));

    await tester.tapAt(const Offset(200, 400));
    await _advance(tester, const Duration(milliseconds: 1500));

    expect(find.bySemanticsLabel(RegExp('^Learn the island first')),
        findsOneWidget);
    semantics.dispose();
  });

  testWidgets('reduce motion shows composed frames and still skips',
      (tester) async {
    final state = await _pumpGate(tester, reduceMotion: true);
    final semantics = tester.ensureSemantics();
    await tester.pump();

    expect(find.bySemanticsLabel(RegExp('^Block Island')), findsOneWidget);

    await _advance(tester,
        OnboardingTiming.reducedHold + const Duration(milliseconds: 500));
    expect(find.bySemanticsLabel(RegExp('^Learn the island first')),
        findsOneWidget);

    await tester.tap(find.text('Skip'));
    await _advance(tester, _afterExit);

    expect(find.byType(OnboardingOverlay), findsNothing);
    expect(state.hasSeenOnboarding, isTrue);
    semantics.dispose();
  });
}
