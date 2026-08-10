import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../users/models/user_filter.dart';
import '../../../users/models/user_model.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../providers/site_providers.dart';

class AssignSupervisorDialog extends ConsumerStatefulWidget {
  const AssignSupervisorDialog({super.key, required this.siteId});

  final int siteId;

  static Future<bool?> show(BuildContext context, {required int siteId}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AssignSupervisorDialog(siteId: siteId),
    );
  }

  @override
  ConsumerState<AssignSupervisorDialog> createState() =>
      _AssignSupervisorDialogState();
}

class _AssignSupervisorDialogState
    extends ConsumerState<AssignSupervisorDialog> {
  UserModel? _selectedSupervisor;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userRepo = ref.watch(userRepositoryProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assign Supervisor to Site',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<({List<UserModel> items, int total})>(
                future: userRepo.fetchUsers(
                  const UserFilter(
                    roleFilter: UserRoleFilter.supervisor,
                    statusFilter: UserStatusFilter.active,
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget(label: 'Loading supervisors…');
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'Failed to load supervisor accounts.',
                      style: TextStyle(color: theme.colorScheme.error),
                    );
                  }

                  final supervisors = snapshot.data?.items ?? [];

                  if (supervisors.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No active supervisor accounts found in system.'),
                    );
                  }

                  return DropdownButtonFormField<UserModel>(
                    initialValue: _selectedSupervisor,
                    decoration: const InputDecoration(
                      labelText: 'Select Supervisor *',
                    ),
                    items: supervisors.map((user) {
                      return DropdownMenuItem(
                        value: user,
                        child: Text('${user.fullName} (${user.phone})'),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (val) => setState(() => _selectedSupervisor = val),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  AppPrimaryButton(
                    label: 'Assign',
                    isLoading: _isSubmitting,
                    onPressed: _selectedSupervisor == null || _isSubmitting
                        ? null
                        : _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedSupervisor == null) return;

    setState(() => _isSubmitting = true);
    try {
      final success = await ref
          .read(siteDetailsControllerProvider(widget.siteId).notifier)
          .assignSupervisor(
            _selectedSupervisor!.id,
            supervisorName: _selectedSupervisor!.fullName,
          );

      if (mounted) {
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Supervisor assigned successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to assign supervisor.')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
