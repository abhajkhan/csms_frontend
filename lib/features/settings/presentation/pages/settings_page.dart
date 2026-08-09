import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;
  Object? _error;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(
            oldPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully.')),
        );
      }
    } catch (error) {
      _error = error;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text('Use at least 6 characters for your new password.'),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Current password',
                controller: _currentPasswordController,
                obscureText: true,
                enabled: !_isSaving,
                validator: _passwordValidator,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'New password',
                controller: _newPasswordController,
                obscureText: true,
                enabled: !_isSaving,
                validator: _passwordValidator,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Confirm new password',
                controller: _confirmPasswordController,
                obscureText: true,
                enabled: !_isSaving,
                validator: (value) => value != _newPasswordController.text
                    ? 'Passwords do not match.'
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppErrorWidget(message: _messageFor(_error!)),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: 'Change password',
                icon: Icons.lock_reset_outlined,
                isLoading: _isSaving,
                onPressed: _changePassword,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  String? _passwordValidator(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String _messageFor(Object error) => error is ApiException
      ? error.message
      : 'Unable to change password. Please try again.';
}
