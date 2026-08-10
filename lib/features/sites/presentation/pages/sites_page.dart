import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/layouts/responsive_layout.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/models/auth_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../models/site_model.dart';
import '../dialogs/add_edit_site_dialog.dart';
import '../providers/site_providers.dart';
import '../widgets/site_card_list.dart';
import '../widgets/site_data_table.dart';
import '../widgets/site_filter_bar.dart';

class SitesPage extends ConsumerWidget {
  const SitesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(siteListControllerProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    final userRole = ref.watch(
      authControllerProvider.select((s) => s.valueOrNull?.user?.role),
    );
    final isAdmin = userRole == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(siteListControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: (isMobile && isAdmin)
          ? FloatingActionButton(
              onPressed: () => _openAddSiteDialog(context),
              child: const Icon(Icons.add_location_alt_outlined),
            )
          : null,
      body: listAsync.when(
        loading: () => const LoadingWidget(label: 'Loading construction sites…'),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load sites: ${error.toString()}',
          onRetry: () => ref.read(siteListControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SiteFilterBar(
                  filter: state.filter,
                  onSearchChanged: (query) {
                    ref.read(siteListControllerProvider.notifier).search(query);
                  },
                  onStatusFilterChanged: (statusFilter) {
                    ref
                        .read(siteListControllerProvider.notifier)
                        .setStatusFilter(statusFilter);
                  },
                  onAddSitePressed: isAdmin ? () => _openAddSiteDialog(context) : null,
                ),
                const SizedBox(height: 16),
                if (state.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: EmptyWidget(
                      title: 'No Sites Found',
                      message: state.filter.searchQuery.isNotEmpty
                          ? 'No site matching "${state.filter.searchQuery}" was found.'
                          : isAdmin
                              ? 'No construction sites registered yet. Click below to add a new site.'
                              : 'No construction sites registered yet.',
                      action: isAdmin
                          ? ElevatedButton.icon(
                              onPressed: () => _openAddSiteDialog(context),
                              icon: const Icon(Icons.add_location_alt_outlined),
                              label: const Text('Add Site'),
                            )
                          : null,
                    ),
                  )
                else ...[
                  ResponsiveLayout(
                    mobile: SiteCardList(
                      sites: state.sites,
                      onViewDetails: (s) => _navigateToDetails(context, s.id),
                      onEdit: isAdmin ? (s) => _openEditSiteDialog(context, s) : null,
                      onToggleStatus: isAdmin
                          ? (s) => _toggleStatus(context, ref, s)
                          : null,
                    ),
                    tablet: SiteDataTable(
                      sites: state.sites,
                      onViewDetails: (s) => _navigateToDetails(context, s.id),
                      onEdit: isAdmin ? (s) => _openEditSiteDialog(context, s) : null,
                      onToggleStatus: isAdmin
                          ? (s) => _toggleStatus(context, ref, s)
                          : null,
                    ),
                    desktop: SiteDataTable(
                      sites: state.sites,
                      onViewDetails: (s) => _navigateToDetails(context, s.id),
                      onEdit: isAdmin ? (s) => _openEditSiteDialog(context, s) : null,
                      onToggleStatus: isAdmin
                          ? (s) => _toggleStatus(context, ref, s)
                          : null,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetails(BuildContext context, int siteId) {
    context.go('/sites/$siteId');
  }

  void _openAddSiteDialog(BuildContext context) {
    AddEditSiteDialog.show(context);
  }

  void _openEditSiteDialog(BuildContext context, SiteModel site) {
    AddEditSiteDialog.show(context, site: site);
  }

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    SiteModel site,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Change Status for ${site.name}?'),
        content: Text(
          'Are you sure you want to change site status to "${site.status.label}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(siteListControllerProvider.notifier)
          .updateSiteStatus(site.id, site.status);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Site status updated to ${site.status.label}.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update site status.')),
          );
        }
      }
    }
  }
}
