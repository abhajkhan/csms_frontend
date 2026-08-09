import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/layouts/responsive_layout.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../models/user_model.dart';
import '../dialogs/add_user_dialog.dart';
import '../dialogs/edit_user_dialog.dart';
import '../providers/user_providers.dart';
import '../widgets/user_card_list.dart';
import '../widgets/user_data_table.dart';
import '../widgets/user_filter_bar.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(userListControllerProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Users',
            onPressed: () => ref.read(userListControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () => _openAddUserDialog(context, ref),
              child: const Icon(Icons.person_add),
            )
          : null,
      body: listAsync.when(
        loading: () => const LoadingWidget(label: 'Loading users…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load users: ${error.toString()}',
          onRetry: () => ref.read(userListControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserFilterBar(
                  filter: state.filter,
                  onSearchChanged: (query) {
                    ref.read(userListControllerProvider.notifier).search(query);
                  },
                  onRoleFilterChanged: (roleFilter) {
                    ref
                        .read(userListControllerProvider.notifier)
                        .setRoleFilter(roleFilter);
                  },
                  onStatusFilterChanged: (statusFilter) {
                    ref
                        .read(userListControllerProvider.notifier)
                        .setStatusFilter(statusFilter);
                  },
                  onAddUserPressed: () => _openAddUserDialog(context, ref),
                ),
                const SizedBox(height: 16),
                if (state.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: EmptyWidget(
                      title: 'No Users Found',
                      message: state.filter.searchQuery.isNotEmpty
                          ? 'No user matching "${state.filter.searchQuery}" was found.'
                          : 'No user accounts registered yet.',
                      action: ElevatedButton.icon(
                        onPressed: () => _openAddUserDialog(context, ref),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add User'),
                      ),
                    ),
                  )
                else ...[
                  ResponsiveLayout(
                    mobile: UserCardList(
                      users: state.users,
                      onViewDetails: (u) => _navigateToDetails(context, u.id),
                      onEdit: (u) => _openEditUserDialog(context, ref, u),
                      onToggleStatus: (u) => _toggleStatus(context, ref, u),
                    ),
                    tablet: UserDataTable(
                      users: state.users,
                      onViewDetails: (u) => _navigateToDetails(context, u.id),
                      onEdit: (u) => _openEditUserDialog(context, ref, u),
                      onToggleStatus: (u) => _toggleStatus(context, ref, u),
                    ),
                    desktop: UserDataTable(
                      users: state.users,
                      onViewDetails: (u) => _navigateToDetails(context, u.id),
                      onEdit: (u) => _openEditUserDialog(context, ref, u),
                      onToggleStatus: (u) => _toggleStatus(context, ref, u),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${state.totalCount} user(s)',
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
                                    .read(userListControllerProvider.notifier)
                                    .changePage(state.filter.page - 1)
                                : null,
                          ),
                          Text('Page ${state.filter.page}'),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: state.users.length >= state.filter.pageSize
                                ? () => ref
                                    .read(userListControllerProvider.notifier)
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

  void _navigateToDetails(BuildContext context, int userId) {
    context.push('/users/$userId');
  }

  Future<void> _openAddUserDialog(BuildContext context, WidgetRef ref) async {
    final result = await AddUserDialog.show(context);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User "${result.fullName}" created successfully.')),
      );
    }
  }

  Future<void> _openEditUserDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final result = await EditUserDialog.show(context, user: user);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User "${result.fullName}" updated successfully.')),
      );
    }
  }

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final isDeactivating = user.isActive;
    final actionName = isDeactivating ? 'deactivate' : 'activate';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${isDeactivating ? "Deactivate" : "Activate"} User Account?'),
        content: Text(
          'Are you sure you want to $actionName user "${user.fullName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(isDeactivating ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = isDeactivating
          ? await ref
              .read(userListControllerProvider.notifier)
              .deactivateUser(user.id)
          : await ref
              .read(userListControllerProvider.notifier)
              .activateUser(user.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User "${user.fullName}" is now ${isDeactivating ? "Inactive" : "Active"}.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update user account status.'),
            ),
          );
        }
      }
    }
  }
}
