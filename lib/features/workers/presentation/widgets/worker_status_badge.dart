import 'package:flutter/material.dart';

class WorkerStatusBadge extends StatelessWidget {
  const WorkerStatusBadge({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isActive
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final foregroundColor = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_outline : Icons.pause_circle_outline,
            size: 14,
            color: foregroundColor,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
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
