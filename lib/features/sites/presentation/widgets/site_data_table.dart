import 'package:flutter/material.dart';
import '../../models/site_model.dart';
import 'site_status_badge.dart';

class SiteDataTable extends StatelessWidget {
  const SiteDataTable({
    super.key,
    required this.sites,
    required this.onViewDetails,
    this.onEdit,
    this.onToggleStatus,
  });

  final List<SiteModel> sites;
  final ValueChanged<SiteModel> onViewDetails;
  final ValueChanged<SiteModel>? onEdit;
  final ValueChanged<SiteModel>? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 64,
            ),
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateProperty.all(
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              columns: const [
                DataColumn(
                  label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Site Name', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Created Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              rows: sites.map((site) {
                return DataRow(
                  onSelectChanged: (_) => onViewDetails(site),
                  cells: [
                    DataCell(Text('#${site.id}')),
                    DataCell(
                      InkWell(
                        onTap: () => onViewDetails(site),
                        child: Text(
                          site.name,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(site.location ?? 'N/A')),
                    DataCell(SiteStatusBadge(status: site.status)),
                    DataCell(Text(site.formattedDate)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 20),
                            tooltip: 'View Details',
                            onPressed: () => onViewDetails(site),
                          ),
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Edit Site',
                              onPressed: () => onEdit!(site),
                            ),
                          if (onToggleStatus != null)
                            PopupMenuButton<SiteStatus>(
                              icon: const Icon(Icons.more_vert, size: 20),
                              tooltip: 'Change Status',
                              onSelected: (newStatus) {
                                if (newStatus != site.status) {
                                  onToggleStatus!(
                                    site.copyWith(status: newStatus),
                                  );
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
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
