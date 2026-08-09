import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_card.dart';
import '../../../auth/models/auth_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../users/presentation/widgets/user_role_badge.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user),
    );

    final theme = Theme.of(context);

    if (user == null) {
      return const AppCard(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('User profile unavailable.'),
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge?.copyWith(
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
              UserRoleBadge(role: user.role),
            ],
          ),
          const Divider(height: 28),
          _ProfileRow(
            icon: Icons.phone_outlined,
            label: 'Phone / Username',
            value: user.username,
          ),
          const SizedBox(height: 12),
          _ProfileRow(
            icon: Icons.badge_outlined,
            label: 'Account Role',
            value: switch (user.role) {
              UserRole.admin => 'Administrator',
              UserRole.supervisor => 'Supervisor',
              UserRole.driver => 'Driver',
            },
          ),
          const SizedBox(height: 12),
          _ProfileRow(
            icon: Icons.check_circle_outline,
            label: 'Account Status',
            value: 'Active',
            valueColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
