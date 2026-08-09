import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../providers/settings_providers.dart';

class ChangePasswordCard extends ConsumerStatefulWidget {
  const ChangePasswordCard({super.key});

  @override
  ConsumerState<ChangePasswordCard> createState() =>
      _ChangePasswordCardState();
}

class _ChangePasswordCardState extends ConsumerState<ChangePasswordCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(changePasswordControllerProvider.notifier);
    final success = await controller.changePassword(
      oldPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (mounted) {
      if (success) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);
    final controller = ref.watch(changePasswordControllerProvider.notifier);
    final isLoading = state.isLoading;
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Change Password',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Use at least 6 characters for your new password.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Current Password *',
              controller: _currentPasswordController,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required.';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'New Password *',
              controller: _newPasswordController,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required.';
                }
                if (value.length < 6) {
                  return 'New password must be at least 6 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm New Password *',
              controller: _confirmPasswordController,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            if (state.hasError && controller.errorMessage != null) ...[
              const SizedBox(height: 16),
              AppErrorWidget(message: controller.errorMessage!),
            ],
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'Change Password',
              icon: Icons.lock_reset_outlined,
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
