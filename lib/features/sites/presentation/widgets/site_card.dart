import 'package:flutter/material.dart';
import '../../../../shared/components/app_card.dart';
import '../../models/site_model.dart';
import 'site_status_badge.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    super.key,
    required this.site,
    required this.onViewDetails,
    this.onEdit,
    this.onToggleStatus,
  });

  final SiteModel site;
  final VoidCallback onViewDetails;
  final VoidCallback? onEdit;
  final ValueChanged<SiteStatus>? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: #${site.id}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SiteStatusBadge(status: site.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  site.location ?? 'No location provided',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Created: ${site.formattedDate}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('Details'),
                onPressed: onViewDetails,
              ),
              if (onEdit != null) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  onPressed: onEdit,
                ),
              ],
              if (onToggleStatus != null) ...[
                const SizedBox(width: 8),
                PopupMenuButton<SiteStatus>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  tooltip: 'Change Status',
                  onSelected: (newStatus) {
                    if (newStatus != site.status) {
                      onToggleStatus!(newStatus);
                    }
                  },
                  itemBuilder: (context) => [
                    if (site.status != SiteStatus.active)
                      const PopupMenuItem(
                        value: SiteStatus.active,
                        child: Text('Mark Active'),
                      ),
                    if (site.status != SiteStatus.onHold)
                      const PopupMenuItem(
                        value: SiteStatus.onHold,
                        child: Text('Put on Hold'),
                      ),
                    if (site.status != SiteStatus.completed)
                      const PopupMenuItem(
                        value: SiteStatus.completed,
                        child: Text('Archive / Complete'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
