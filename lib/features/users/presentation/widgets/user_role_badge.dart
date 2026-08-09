import 'package:flutter/material.dart';
import '../../../auth/models/auth_user.dart';

class UserRoleBadge extends StatelessWidget {
  const UserRoleBadge({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (label, backgroundColor, foregroundColor) = switch (role) {
      UserRole.admin => (
        'Admin',
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      UserRole.supervisor => (
        'Supervisor',
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      UserRole.driver => (
        'Driver',
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
