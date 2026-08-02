import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/attendance/presentation/pages/attendance_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/models/auth_state.dart';
import '../features/auth/models/auth_user.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/expenses/presentation/pages/expenses_page.dart';
import '../features/reports/presentation/pages/reports_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/sites/presentation/pages/sites_page.dart';
import '../features/workers/presentation/pages/workers_page.dart';
import '../shared/layouts/page_scaffold.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const dashboard = '/dashboard';
  static const workers = '/workers';
  static const sites = '/sites';
  static const attendance = '/attendance';
  static const expenses = '/expenses';
  static const reports = '/reports';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter(ref);
  ref.listen(authControllerProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createAppRouter(Ref ref) => GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    final authState = ref.read(authControllerProvider);
    final session = authState.valueOrNull;
    final isChecking =
        authState.isLoading || session?.status == AuthStatus.checking;
    final location = state.uri.path;
    final isPublicRoute =
        location == AppRoutes.login || location == AppRoutes.forgotPassword;

    if (isChecking) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }
    if (session == null || !session.isAuthenticated) {
      return isPublicRoute ? null : AppRoutes.login;
    }
    if (location == AppRoutes.splash || isPublicRoute) {
      return _defaultRouteFor(session.user!.role);
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppPageScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.workers,
              builder: (context, state) => const WorkersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.sites,
              builder: (context, state) => const SitesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendancePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.expenses,
              builder: (context, state) => const ExpensesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.reports,
              builder: (context, state) => const ReportsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri.path}'))),
);

String _defaultRouteFor(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return AppRoutes.dashboard;
    case UserRole.supervisor:
      return AppRoutes.expenses;
    case UserRole.driver:
      return AppRoutes.dashboard;
  }
}
