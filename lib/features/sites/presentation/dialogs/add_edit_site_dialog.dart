import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../models/site_model.dart';
import '../providers/site_providers.dart';

class AddEditSiteDialog extends ConsumerStatefulWidget {
  const AddEditSiteDialog({super.key, this.site});

  final SiteModel? site;

  static Future<bool?> show(BuildContext context, {SiteModel? site}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddEditSiteDialog(site: site),
    );
  }

  @override
  ConsumerState<AddEditSiteDialog> createState() => _AddEditSiteDialogState();
}

class _AddEditSiteDialogState extends ConsumerState<AddEditSiteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late SiteStatus _selectedStatus;

  bool get isEditing => widget.site != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.site?.name ?? '');
    _locationController = TextEditingController(text: widget.site?.location ?? '');
    _selectedStatus = widget.site?.status ?? SiteStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(siteFormControllerProvider.notifier);

    if (isEditing) {
      final result = await controller.updateSite(
        siteId: widget.site!.id,
        siteName: _nameController.text.trim(),
        location: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        status: _selectedStatus,
      );

      if (result != null && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site updated successfully.')),
        );
      }
    } else {
      final result = await controller.createSite(
        siteName: _nameController.text.trim(),
        location: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
      );

      if (result != null && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site registered successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(siteFormControllerProvider);
    final isLoading = formState.isLoading;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Construction Site' : 'Register New Site',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Site Name *',
                  controller: _nameController,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Site name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Location Address',
                  controller: _locationController,
                  enabled: !isLoading,
                ),
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<SiteStatus>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Site Status *',
                    ),
                    items: SiteStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => _selectedStatus = val);
                            }
                          },
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AppPrimaryButton(
                      label: isEditing ? 'Save Changes' : 'Register Site',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
