import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../features/auth/models/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import 'responsive_layout.dart';

class AppPageScaffold extends ConsumerWidget {
  const AppPageScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  static final _allDestinations = <_NavigationDestination>[
    _NavigationDestination(
      'Dashboard',
      Icons.dashboard_outlined,
      AppRoutes.dashboard,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Workers',
      Icons.groups_outlined,
      AppRoutes.workers,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Sites',
      Icons.location_city_outlined,
      AppRoutes.sites,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Attendance',
      Icons.fact_check_outlined,
      AppRoutes.attendance,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Expenses',
      Icons.receipt_long_outlined,
      AppRoutes.expenses,
      roles: [UserRole.admin, UserRole.supervisor],
    ),
    _NavigationDestination(
      'Reports',
      Icons.assessment_outlined,
      AppRoutes.reports,
      roles: [UserRole.admin],
    ),
    _NavigationDestination(
      'Settings',
      Icons.settings_outlined,
      AppRoutes.settings,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user?.role),
    );

    if (userRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final destinations = _allDestinations.where((d) {
      if (d.roles == null) return true;
      return d.roles!.contains(userRole);
    }).toList();

    final currentLocation = GoRouterState.of(context).uri.path;
    // Reverse search or check longer routes first so '/' doesn't hijack everything
    final rawIndex = destinations.indexWhere(
      (item) => item.route != '/'
          ? currentLocation.startsWith(item.route)
          : currentLocation == '/',
    );

    // Fallback to tab 0 if no match found
    final selectedIndex = rawIndex == -1 ? 0 : rawIndex;
    final content = _PageContent(title: title, child: child);
    final mobileDestinations = _mobileDestinations(destinations);
    final mobileSelectedIndex = _mobileSelectedIndex(
      destinations: destinations,
      mobileDestinations: mobileDestinations,
      currentLocation: currentLocation,
    );

    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: content,
        bottomNavigationBar: destinations.isEmpty
            ? null
            : NavigationBar(
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
                  context.go(destination.route);
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
            if (destinations.isNotEmpty) ...[
              NavigationRail(
                selectedIndex: selectedIndex,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (index) =>
                    context.go(destinations[index].route),
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
            ],
            Expanded(child: content),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 240,
              child: destinations.isEmpty
                  ? null
                  : NavigationDrawer(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (index) =>
                          context.go(destinations[index].route),
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
    const primaryRoutes = {
      AppRoutes.dashboard,
      AppRoutes.workers,
      AppRoutes.expenses,
    };
    final primary = destinations
        .where((item) => primaryRoutes.contains(item.route))
        .toList();

    if (destinations.length <= 5) return destinations;
    return [...primary, _NavigationDestination.more];
  }

  int _mobileSelectedIndex({
    required List<_NavigationDestination> destinations,
    required List<_NavigationDestination> mobileDestinations,
    required String currentLocation,
  }) {
    final fullSelected = destinations.firstWhere(
      (item) => currentLocation.startsWith(item.route),
      orElse: () => mobileDestinations.first,
    );
    final index = mobileDestinations.indexOf(fullSelected);
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
                  context.go(item.route);
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
  const _NavigationDestination(this.label, this.icon, this.route, {this.roles});

  static const more = _NavigationDestination(
    'More',
    Icons.more_horiz_outlined,
    '',
  );

  final String label;
  final IconData icon;
  final String route;
  final List<UserRole>? roles;

  bool get isMore => route.isEmpty;
}
