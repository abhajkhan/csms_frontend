import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../models/user_model.dart';
import '../providers/user_providers.dart';

class EditUserDialog extends ConsumerStatefulWidget {
  const EditUserDialog({super.key, required this.user});

  final UserModel user;

  static Future<UserModel?> show(BuildContext context, {required UserModel user}) =>
      showDialog<UserModel>(
        context: context,
        barrierDismissible: false,
        builder: (context) => EditUserDialog(user: user),
      );

  @override
  ConsumerState<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final formNotifier = ref.read(userFormControllerProvider.notifier);
    final result = await formNotifier.updateUser(
      userId: widget.user.id,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
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
      title: Text('Edit Profile: ${widget.user.fullName}'),
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
                      'Failed to update user profile.',
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                AppTextField(
                  label: 'Full Name *',
                  controller: _nameController,
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
                Text(
                  'Role: ${widget.user.roleLabel} (non-editable)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
          label: 'Save Changes',
          isLoading: isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
