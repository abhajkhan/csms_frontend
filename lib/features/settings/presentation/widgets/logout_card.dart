import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/app_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class LogoutCard extends ConsumerStatefulWidget {
  const LogoutCard({super.key});

  @override
  ConsumerState<LogoutCard> createState() => _LogoutCardState();
}

class _LogoutCardState extends ConsumerState<LogoutCard> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out of CSMS?'),
        content: const Text(
          'Are you sure you want to log out? You will need to sign in again to access the system.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoggingOut = true);
      try {
        await ref.read(authControllerProvider.notifier).logout();
      } finally {
        if (mounted) setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.logout,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 10),
              Text(
                'Log Out',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Sign out of your account on this device.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: _isLoggingOut
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.error,
                        ),
                      ),
                    )
                  : const Icon(Icons.logout),
              label: Text(_isLoggingOut ? 'Logging out…' : 'Log Out'),
              onPressed: _isLoggingOut ? null : _handleLogout,
            ),
          ),
        ],
      ),
    );
  }
}
