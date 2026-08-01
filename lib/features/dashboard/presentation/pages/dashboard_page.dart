import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppPageScaffold(
    title: 'Dashboard',
    child: Column(
      children: [
        const Expanded(child: PlaceholderPageBody(moduleName: 'Dashboard')),
        Align(
          alignment: Alignment.centerRight,
          child: AppSecondaryButton(
            label: 'Sign out',
            icon: Icons.logout,
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    ),
  );
}
