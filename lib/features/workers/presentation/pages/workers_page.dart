import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/models/auth_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../shared/layouts/responsive_layout.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../models/worker.dart';
import '../dialogs/add_edit_worker_dialog.dart';
import '../providers/worker_providers.dart';
import '../widgets/worker_card_list.dart';
import '../widgets/worker_data_table.dart';
import '../widgets/worker_filter_bar.dart';

class WorkersPage extends ConsumerWidget {
  const WorkersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(workerListControllerProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    final theme = Theme.of(context);

    final userRole = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user?.role),
    );
    final isAdmin = userRole == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(workerListControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: (isMobile && isAdmin)
          ? FloatingActionButton(
              onPressed: () => _openAddWorkerDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
      body: listAsync.when(
        loading: () => const LoadingWidget(label: 'Loading workers…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load workers: ${error.toString()}',
          onRetry: () => ref.read(workerListControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkerFilterBar(
                  filter: state.filter,
                  onSearchChanged: (query) {
                    ref.read(workerListControllerProvider.notifier).search(query);
                  },
                  onStatusFilterChanged: (statusFilter) {
                    ref
                        .read(workerListControllerProvider.notifier)
                        .setStatusFilter(statusFilter);
                  },
                  onAddWorkerPressed: isAdmin
                      ? () => _openAddWorkerDialog(context, ref)
                      : null,
                ),
                const SizedBox(height: 16),
                if (state.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: EmptyWidget(
                      title: 'No Workers Found',
                      message: state.filter.searchQuery.isNotEmpty
                          ? 'No worker matching "${state.filter.searchQuery}" was found.'
                          : isAdmin
                              ? 'No workers registered yet. Click below to add a new worker.'
                              : 'No workers registered yet.',
                      action: isAdmin
                          ? ElevatedButton.icon(
                              onPressed: () => _openAddWorkerDialog(context, ref),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Worker'),
                            )
                          : null,
                    ),
                  )
                else ...[
                  ResponsiveLayout(
                    mobile: WorkerCardList(
                      workers: state.workers,
                      onViewDetails: (w) => _navigateToDetails(context, w.id),
                      onEdit: (w) => _openEditWorkerDialog(context, ref, w),
                      onToggleStatus: (w) => _toggleStatus(context, ref, w),
                    ),
                    tablet: WorkerDataTable(
                      workers: state.workers,
                      onViewDetails: (w) => _navigateToDetails(context, w.id),
                      onEdit: (w) => _openEditWorkerDialog(context, ref, w),
                      onToggleStatus: (w) => _toggleStatus(context, ref, w),
                    ),
                    desktop: WorkerDataTable(
                      workers: state.workers,
                      onViewDetails: (w) => _navigateToDetails(context, w.id),
                      onEdit: (w) => _openEditWorkerDialog(context, ref, w),
                      onToggleStatus: (w) => _toggleStatus(context, ref, w),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${state.totalCount} worker(s)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: state.filter.page > 1
                                ? () => ref
                                    .read(workerListControllerProvider.notifier)
                                    .changePage(state.filter.page - 1)
                                : null,
                          ),
                          Text('Page ${state.filter.page}'),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: state.workers.length >= state.filter.pageSize
                                ? () => ref
                                    .read(workerListControllerProvider.notifier)
                                    .changePage(state.filter.page + 1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetails(BuildContext context, int workerId) {
    context.push('/workers/$workerId');
  }

  Future<void> _openAddWorkerDialog(BuildContext context, WidgetRef ref) async {
    final result = await AddEditWorkerDialog.show(context);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Worker "${result.fullName}" added successfully.')),
      );
    }
  }

  Future<void> _openEditWorkerDialog(
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
        content: Text(
          'Are you sure you want to $actionName "${worker.fullName}"?',
        ),
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
          .read(workerListControllerProvider.notifier)
          .toggleWorkerStatus(worker.id, isActive: newStatus);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Worker "${worker.fullName}" is now ${newStatus ? "Active" : "Inactive"}.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update worker status.'),
            ),
          );
        }
      }
    }
  }
}
