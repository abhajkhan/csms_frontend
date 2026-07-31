import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/attendance/presentation/pages/attendance_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/expenses/presentation/pages/expenses_page.dart';
import '../features/reports/presentation/pages/reports_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/sites/presentation/pages/sites_page.dart';
import '../features/workers/presentation/pages/workers_page.dart';

abstract final class AppRoutes {
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

GoRouter createAppRouter() => GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.workers,
      builder: (context, state) => const WorkersPage(),
    ),
    GoRoute(
      path: AppRoutes.sites,
      builder: (context, state) => const SitesPage(),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => const AttendancePage(),
    ),
    GoRoute(
      path: AppRoutes.expenses,
      builder: (context, state) => const ExpensesPage(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri.path}'))),
);
