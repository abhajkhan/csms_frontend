import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CSMS',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign-in functionality will be added in the authentication feature.',
                  ),
                  const SizedBox(height: 16),
                  AppTextButton(
                    label: 'Forgot password?',
                    onPressed: () => context.go(AppRoutes.forgotPassword),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
