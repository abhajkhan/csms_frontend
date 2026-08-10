import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/models/auth_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../dialogs/add_edit_site_dialog.dart';
import '../dialogs/assign_supervisor_dialog.dart';
import '../providers/site_providers.dart';
import '../widgets/site_status_badge.dart';

class SiteDetailsPage extends ConsumerWidget {
  const SiteDetailsPage({super.key, required this.siteId});

  final int siteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(siteDetailsControllerProvider(siteId));
    final theme = Theme.of(context);

    final userRole = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user?.role),
    );
    final isAdmin = userRole == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text('Site Details #$siteId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/sites'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(siteDetailsControllerProvider(siteId).notifier).refresh(),
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => const LoadingWidget(label: 'Loading site profile…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load site details: ${error.toString()}',
          onRetry: () =>
              ref.read(siteDetailsControllerProvider(siteId).notifier).refresh(),
        ),
        data: (data) {
          final site = data.site;
          final supervisors = data.supervisors;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Card
                    AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.location_city,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      site.name,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Site ID: #${site.id}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SiteStatusBadge(status: site.status),
                            ],
                          ),
                          const Divider(height: 28),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  site.location ?? 'No location provided',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Created: ${site.formattedDate}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                'Created By Admin #${site.createdBy}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          if (isAdmin) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  label: const Text('Edit Site'),
                                  onPressed: () =>
                                      AddEditSiteDialog.show(context, site: site),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Assigned Supervisors Section
                    AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.supervisor_account_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Assigned Supervisors',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (isAdmin)
                                AppPrimaryButton(
                                  label: 'Assign Supervisor',
                                  icon: Icons.person_add_alt_outlined,
                                  onPressed: () => AssignSupervisorDialog.show(
                                    context,
                                    siteId: site.id,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (supervisors.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'No supervisors currently assigned to this site.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: supervisors.length,
                              separatorBuilder: (_, _) => const Divider(height: 16),
                              itemBuilder: (context, index) {
                                final sup = supervisors[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        theme.colorScheme.secondaryContainer,
                                    child: Icon(
                                      Icons.person,
                                      color:
                                          theme.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  title: Text(
                                    sup.supervisorName ??
                                        'Supervisor #${sup.supervisorId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Assigned: ${sup.formattedAssignedDate}${sup.supervisorPhone != null ? " • ${sup.supervisorPhone}" : ""}',
                                  ),
                                  trailing: isAdmin
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.person_remove_outlined,
                                            color: theme.colorScheme.error,
                                          ),
                                          tooltip: 'Remove Assignment',
                                          onPressed: () => _confirmRemoveSupervisor(
                                            context,
                                            ref,
                                            sup.supervisorId,
                                            sup.supervisorName ??
                                                '#${sup.supervisorId}',
                                          ),
                                        )
                                      : null,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmRemoveSupervisor(
    BuildContext context,
    WidgetRef ref,
    int supervisorId,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: const Text(
          'Are you sure you want to deactivate this supervisor\'s assignment from this site?',
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(siteDetailsControllerProvider(siteId).notifier)
          .deactivateSupervisor(supervisorId);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Supervisor assignment removed.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to remove assignment.')),
          );
        }
      }
    }
  }
}
