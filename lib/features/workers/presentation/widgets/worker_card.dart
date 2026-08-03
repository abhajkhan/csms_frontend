import 'package:flutter/material.dart';
import '../../../../shared/components/app_card.dart';
import '../../models/worker.dart';
import 'worker_status_badge.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({
    super.key,
    required this.worker,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final Worker worker;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    worker.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                WorkerStatusBadge(isActive: worker.isActive),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Wage',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  worker.formattedWage,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (worker.phone != null && worker.phone!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    worker.phone!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    worker.isActive ? Icons.pause_circle : Icons.play_circle,
                    color: worker.isActive
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  tooltip: worker.isActive ? 'Deactivate' : 'Activate',
                  onPressed: onToggleStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
