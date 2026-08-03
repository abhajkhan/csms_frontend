import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../models/worker.dart';
import '../dialogs/add_edit_worker_dialog.dart';
import '../providers/worker_providers.dart';
import '../widgets/worker_status_badge.dart';

class WorkerDetailsPage extends ConsumerWidget {
  const WorkerDetailsPage({super.key, required this.workerId});

  final int workerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerAsync = ref.watch(workerDetailsControllerProvider(workerId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(workerDetailsControllerProvider(workerId).notifier).refresh(),
          ),
        ],
      ),
      body: workerAsync.when(
        loading: () => const LoadingWidget(label: 'Loading worker details…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load worker details: ${error.toString()}',
          onRetry: () =>
              ref.read(workerDetailsControllerProvider(workerId).notifier).refresh(),
        ),
        data: (worker) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    worker.fullName,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Worker ID: #${worker.id}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            WorkerStatusBadge(isActive: worker.isActive),
                          ],
                        ),
                        const Divider(height: 32),
                        _DetailRow(
                          label: 'Daily Wage Rate',
                          value: worker.formattedWage,
                          valueStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          label: 'Account Status',
                          value: worker.isActive ? 'Active Worker' : 'Inactive Worker',
                        ),
                        if (worker.createdBy != null) ...[
                          const SizedBox(height: 16),
                          _DetailRow(
                            label: 'Registered By User ID',
                            value: '#${worker.createdBy}',
                          ),
                        ],
                        if (worker.phone != null && worker.phone!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _DetailRow(label: 'Phone', value: worker.phone!),
                        ],
                        if (worker.skill != null && worker.skill!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _DetailRow(label: 'Skill Category', value: worker.skill!),
                        ],
                        if (worker.assignedSite != null && worker.assignedSite!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _DetailRow(label: 'Assigned Site', value: worker.assignedSite!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      AppPrimaryButton(
                        label: 'Edit Worker',
                        icon: Icons.edit,
                        onPressed: () => _editWorker(context, ref, worker),
                      ),
                      const SizedBox(width: 12),
                      AppSecondaryButton(
                        label: worker.isActive ? 'Deactivate' : 'Activate',
                        icon: worker.isActive
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        onPressed: () => _toggleStatus(context, ref, worker),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _editWorker(
    BuildContext context,
    WidgetRef ref,
    Worker worker,
  ) async {
    final result = await AddEditWorkerDialog.show(context, worker: worker);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Worker "${result.fullName}" updated successfully.')),
      );
    }
  }

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    Worker worker,
  ) async {
    final newStatus = !worker.isActive;
    final actionName = newStatus ? 'activate' : 'deactivate';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${newStatus ? "Activate" : "Deactivate"} Worker?'),
        content: Text('Are you sure you want to $actionName "${worker.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(newStatus ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(workerDetailsControllerProvider(worker.id).notifier)
          .toggleStatus(isActive: newStatus);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Worker status updated to ${newStatus ? "Active" : "Inactive"}.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update status.')),
          );
        }
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
