import 'package:flutter/material.dart';

import 'screens/conservation/conservation_screen.dart';
import 'screens/education/education_screen.dart';
import 'screens/exploration/map_screen.dart';
import 'theme/colors.dart';
import 'theme/spacing.dart';
import 'theme/typography.dart';

/// Bottom nav over an IndexedStack. IndexedStack keeps every tab alive, so
/// the map's pan and zoom survive tab switches (smoke test step 2).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Session-only UI state; deliberately not persisted.
  int _index = 0;

  static const _tabs = [EducationScreen(), MapScreen(), ConservationScreen()];

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: AppNavBar(selectedIndex: _index, onSelect: _select),
    );
  }
}

class _NavDestination {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavDestination(this.label, this.icon, this.activeIcon);
}

/// Custom rather than Material's NavigationBar, which brings a pill
/// indicator, tonal surface tint, and elevation DESIGN.md rules out.
///
/// Public so the onboarding's last beat can place an identical bar exactly
/// where this one will be revealed.
class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  static const _destinations = [
    _NavDestination('Education', Icons.menu_book_outlined, Icons.menu_book),
    _NavDestination('Exploration', Icons.map_outlined, Icons.map),
    _NavDestination('Conservation', Icons.eco_outlined, Icons.eco),
  ];

  static const _decoration = BoxDecoration(
    color: AppColors.paper,
    border: Border(top: BorderSide(color: AppColors.hairline, width: 1)),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final (i, destination) in _destinations.indexed)
              Expanded(
                child: _NavItem(
                  destination: destination,
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  static const _indicatorWidth = AppSpace.lg;
  static const _indicatorHeight = 2.0;

  Color get _color => selected ? AppColors.depth : AppColors.inkMuted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Always laid out so icons do not shift as selection moves; left
            // unpainted when inactive so the hairline above stays unbroken.
            SizedBox(
              width: _indicatorWidth,
              height: _indicatorHeight,
              child: selected
                  ? const ColoredBox(color: AppColors.beacon)
                  : null,
            ),
            const SizedBox(height: AppSpace.sm),
            Icon(
              selected ? destination.activeIcon : destination.icon,
              color: _color,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              destination.label,
              style: AppText.label.copyWith(color: _color),
            ),
            const SizedBox(height: AppSpace.sm),
          ],
        ),
      ),
    );
  }
}
