import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../../auth/models/auth_user.dart';
import '../../models/user_model.dart';
import '../providers/user_providers.dart';

class AddUserDialog extends ConsumerStatefulWidget {
  const AddUserDialog({super.key});

  static Future<UserModel?> show(BuildContext context) => showDialog<UserModel>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AddUserDialog(),
      );

  @override
  ConsumerState<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.supervisor;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final formNotifier = ref.read(userFormControllerProvider.notifier);
    final result = await formNotifier.createUser(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (mounted && result != null) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(userFormControllerProvider);
    final isLoading = formState.isLoading;
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Add New User'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (formState.hasError) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Failed to create user. Please check details and try again.',
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                AppTextField(
                  label: 'Full Name *',
                  controller: _nameController,
                  hintText: 'Enter full name',
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required.';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Phone Number *',
                  controller: _phoneController,
                  hintText: 'e.g. +91 98765 43210',
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required.';
                    }
                    if (value.trim().length < 7) {
                      return 'Phone number must be at least 7 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password *',
                  controller: _passwordController,
                  hintText: 'Minimum 6 characters',
                  obscureText: true,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'User Role *',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.supervisor,
                      child: Text('Supervisor'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.driver,
                      child: Text('Driver'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: isLoading
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() => _selectedRole = val);
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AppSecondaryButton(
          label: 'Cancel',
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
        ),
        AppPrimaryButton(
          label: 'Create User',
          isLoading: isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
