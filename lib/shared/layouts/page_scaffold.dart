import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/auth/models/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import 'responsive_layout.dart';

class AppPageScaffold extends ConsumerWidget {
  const AppPageScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final _allDestinations = <_NavigationDestination>[
    _NavigationDestination(
      'Dashboard',
      Icons.dashboard_outlined,
      branchIndex: 0,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Users',
      Icons.manage_accounts_outlined,
      branchIndex: 1,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Workers',
      Icons.groups_outlined,
      branchIndex: 2,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Sites',
      Icons.location_city_outlined,
      branchIndex: 3,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Attendance',
      Icons.fact_check_outlined,
      branchIndex: 4,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Expenses',
      Icons.receipt_long_outlined,
      branchIndex: 5,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Reports',
      Icons.assessment_outlined,
      branchIndex: 6,
      roles: [UserRole.admin],
    ),
    _NavigationDestination('Settings', Icons.settings_outlined, branchIndex: 7),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user?.role),
    );

    if (userRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final destinations = _allDestinations.where((destination) {
      return destination.roles == null || destination.roles!.contains(userRole);
    }).toList();
    final selectedDestination = destinations.firstWhere(
      (destination) => destination.branchIndex == navigationShell.currentIndex,
      orElse: () => destinations.first,
    );
    final mobileDestinations = _mobileDestinations(destinations);
    final mobileSelectedIndex = _mobileSelectedIndex(
      selectedDestination,
      mobileDestinations,
    );
    final content = _PageContent(
      title: selectedDestination.label,
      child: navigationShell,
    );

    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: AppBar(title: Text(selectedDestination.label)),
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: mobileSelectedIndex,
          onDestinationSelected: (index) {
            final destination = mobileDestinations[index];
            if (destination.isMore) {
              _showMoreDestinations(
                context,
                destinations
                    .where((item) => !mobileDestinations.contains(item))
                    .toList(),
              );
              return;
            }
            navigationShell.goBranch(destination.branchIndex!);
          },
          destinations: mobileDestinations
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
              selectedIndex: destinations.indexOf(selectedDestination),
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) =>
                  navigationShell.goBranch(destinations[index].branchIndex!),
              destinations: destinations
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
                selectedIndex: destinations.indexOf(selectedDestination),
                onDestinationSelected: (index) =>
                    navigationShell.goBranch(destinations[index].branchIndex!),
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
                  ...destinations.map(
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

  List<_NavigationDestination> _mobileDestinations(
    List<_NavigationDestination> destinations,
  ) {
    const primaryBranches = {0, 1, 4};
    if (destinations.length <= 5) return destinations;
    return [
      ...destinations.where(
        (destination) => primaryBranches.contains(destination.branchIndex),
      ),
      _NavigationDestination.more,
    ];
  }

  int _mobileSelectedIndex(
    _NavigationDestination selectedDestination,
    List<_NavigationDestination> mobileDestinations,
  ) {
    final index = mobileDestinations.indexOf(selectedDestination);
    return index == -1 ? mobileDestinations.length - 1 : index;
  }

  void _showMoreDestinations(
    BuildContext context,
    List<_NavigationDestination> destinations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('More')),
            ...destinations.map(
              (item) => ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: () {
                  Navigator.pop(sheetContext);
                  navigationShell.goBranch(item.branchIndex!);
                },
              ),
            ),
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
  const _NavigationDestination(
    this.label,
    this.icon, {
    this.branchIndex,
    this.roles,
  });

  static const more = _NavigationDestination('More', Icons.more_horiz_outlined);

  final String label;
  final IconData icon;
  final int? branchIndex;
  final List<UserRole>? roles;

  bool get isMore => branchIndex == null;
}
