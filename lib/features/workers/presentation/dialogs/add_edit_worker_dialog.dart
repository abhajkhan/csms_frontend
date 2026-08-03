import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../models/worker.dart';
import '../providers/worker_providers.dart';

class AddEditWorkerDialog extends ConsumerStatefulWidget {
  const AddEditWorkerDialog({super.key, this.worker});

  final Worker? worker;

  static Future<Worker?> show(BuildContext context, {Worker? worker}) =>
      showDialog<Worker>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWorkerDialog(worker: worker),
      );

  @override
  ConsumerState<AddEditWorkerDialog> createState() =>
      _AddEditWorkerDialogState();
}

class _AddEditWorkerDialogState extends ConsumerState<AddEditWorkerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _wageController;
  late bool _isActive;

  bool get isEditing => widget.worker != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.worker?.fullName ?? '');
    _wageController = TextEditingController(
      text: widget.worker != null ? widget.worker!.dailyWage.toStringAsFixed(2) : '',
    );
    _isActive = widget.worker?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final wage = double.parse(_wageController.text.trim());

    final formNotifier = ref.read(workerFormControllerProvider.notifier);
    Worker? result;

    if (isEditing) {
      result = await formNotifier.updateWorker(
        workerId: widget.worker!.id,
        fullName: name,
        dailyWage: wage,
        isActive: _isActive,
      );
    } else {
      result = await formNotifier.createWorker(
        fullName: name,
        dailyWage: wage,
        isActive: _isActive,
      );
    }

    if (mounted && result != null) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(workerFormControllerProvider);
    final isLoading = formState.isLoading;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(isEditing ? 'Edit Worker' : 'Add New Worker'),
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
                      'Failed to save worker. Please check inputs and retry.',
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                AppTextField(
                  label: 'Full Name *',
                  controller: _nameController,
                  hintText: 'Enter worker full name',
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Worker name is required.';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Daily Wage (₹) *',
                  controller: _wageController,
                  hintText: 'e.g. 750.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Daily wage is required.';
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid positive daily wage.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active Status'),
                  subtitle: Text(_isActive ? 'Worker is active' : 'Worker is inactive'),
                  value: _isActive,
                  onChanged: isLoading
                      ? null
                      : (val) => setState(() => _isActive = val),
                  contentPadding: EdgeInsets.zero,
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
          label: isEditing ? 'Save Changes' : 'Create Worker',
          isLoading: isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
