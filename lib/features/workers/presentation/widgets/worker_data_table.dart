import 'package:flutter/material.dart';
import '../../models/worker.dart';
import 'worker_status_badge.dart';

class WorkerDataTable extends StatelessWidget {
  const WorkerDataTable({
    super.key,
    required this.workers,
    required this.onViewDetails,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final List<Worker> workers;
  final ValueChanged<Worker> onViewDetails;
  final ValueChanged<Worker> onEdit;
  final ValueChanged<Worker> onToggleStatus;

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
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Worker Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Daily Wage', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: workers.map((worker) {
            return DataRow(
              cells: [
                DataCell(Text('#${worker.id}')),
                DataCell(
                  InkWell(
                    onTap: () => onViewDetails(worker),
                    child: Text(
                      worker.fullName,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(worker.formattedWage)),
                DataCell(WorkerStatusBadge(isActive: worker.isActive)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        tooltip: 'View Details',
                        onPressed: () => onViewDetails(worker),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Edit Worker',
                        onPressed: () => onEdit(worker),
                      ),
                      IconButton(
                        icon: Icon(
                          worker.isActive
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 20,
                          color: worker.isActive
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                        tooltip: worker.isActive ? 'Deactivate' : 'Activate',
                        onPressed: () => onToggleStatus(worker),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
