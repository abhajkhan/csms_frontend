import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../models/user_model.dart';
import '../dialogs/edit_user_dialog.dart';
import '../providers/user_providers.dart';
import '../widgets/user_role_badge.dart';
import '../widgets/user_status_badge.dart';

class UserDetailsPage extends ConsumerWidget {
  const UserDetailsPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailsControllerProvider(userId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(userDetailsControllerProvider(userId).notifier).refresh(),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const LoadingWidget(label: 'Loading user details…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load user details: ${error.toString()}',
          onRetry: () =>
              ref.read(userDetailsControllerProvider(userId).notifier).refresh(),
        ),
        data: (user) {
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
                                    user.fullName,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'User ID: #${user.id}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            UserStatusBadge(isActive: user.isActive),
                          ],
                        ),
                        const SizedBox(height: 12),
                        UserRoleBadge(role: user.role),
                        const Divider(height: 32),
                        _DetailRow(
                          label: 'Phone Number',
                          value: user.phone,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          label: 'Assigned Role',
                          value: user.roleLabel,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          label: 'Account Status',
                          value: user.isActive ? 'Active Account' : 'Deactivated Account',
                        ),
                        if (user.driverType != null && user.driverType!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _DetailRow(
                            label: 'Driver Category',
                            value: user.driverType!,
                          ),
                        ],
                        if (user.accBalance != null) ...[
                          const SizedBox(height: 16),
                          _DetailRow(
                            label: 'Wallet Balance',
                            value: user.formattedBalance,
                            valueStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      AppPrimaryButton(
                        label: 'Edit Profile',
                        icon: Icons.edit,
                        onPressed: () => _editUser(context, ref, user),
                      ),
                      const SizedBox(width: 12),
                      AppSecondaryButton(
                        label: user.isActive ? 'Deactivate Account' : 'Activate Account',
                        icon: user.isActive
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        onPressed: () => _toggleStatus(context, ref, user),
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

  Future<void> _editUser(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final result = await EditUserDialog.show(context, user: user);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile for "${result.fullName}" updated.')),
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
        title: Text('${isDeactivating ? "Deactivate" : "Activate"} Account?'),
        content: Text('Are you sure you want to $actionName user "${user.fullName}"?'),
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
      final notifier = ref.read(userDetailsControllerProvider(user.id).notifier);
      final success = isDeactivating ? await notifier.deactivate() : await notifier.activate();

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User status updated to ${isDeactivating ? "Inactive" : "Active"}.',
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
