import 'package:flutter/material.dart';
import '../../models/site_model.dart';

class SiteStatusBadge extends StatelessWidget {
  const SiteStatusBadge({super.key, required this.status});

  final SiteStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (label, icon, backgroundColor, foregroundColor) = switch (status) {
      SiteStatus.active => (
        'Active',
        Icons.check_circle_outline,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      SiteStatus.completed => (
        'Completed',
        Icons.task_alt,
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      SiteStatus.onHold => (
        'On Hold',
        Icons.pause_circle_outline,
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
