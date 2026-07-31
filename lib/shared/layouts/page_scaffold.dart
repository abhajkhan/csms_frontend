import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import 'responsive_layout.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  static const _destinations = [
    _NavigationDestination(
      'Dashboard',
      Icons.dashboard_outlined,
      AppRoutes.dashboard,
    ),
    _NavigationDestination('Workers', Icons.groups_outlined, AppRoutes.workers),
    _NavigationDestination(
      'Sites',
      Icons.location_city_outlined,
      AppRoutes.sites,
    ),
    _NavigationDestination(
      'Attendance',
      Icons.fact_check_outlined,
      AppRoutes.attendance,
    ),
    _NavigationDestination(
      'Expenses',
      Icons.receipt_long_outlined,
      AppRoutes.expenses,
    ),
    _NavigationDestination(
      'Reports',
      Icons.assessment_outlined,
      AppRoutes.reports,
    ),
    _NavigationDestination(
      'Settings',
      Icons.settings_outlined,
      AppRoutes.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final selectedIndex = _destinations
        .indexWhere((item) => item.route == currentLocation)
        .clamp(0, _destinations.length - 1);
    final content = _PageContent(title: title, child: child);

    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              context.go(_destinations[index].route),
          destinations: _destinations
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
      tablet: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) =>
                  context.go(_destinations[index].route),
              destinations: _destinations
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 240,
              child: NavigationDrawer(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) =>
                    context.go(_destinations[index].route),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'CSMS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ..._destinations.map(
                    (item) => NavigationDrawerDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveLayout.isMobile(context) ? AppSpacing.md : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!ResponsiveLayout.isMobile(context)) ...[
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.lg),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );
}

class _NavigationDestination {
  const _NavigationDestination(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}
