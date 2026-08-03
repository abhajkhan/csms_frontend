import 'package:flutter/material.dart';
import '../../models/worker_filter.dart';

class WorkerFilterBar extends StatefulWidget {
  const WorkerFilterBar({
    super.key,
    required this.filter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    this.onAddWorkerPressed,
  });

  final WorkerFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<WorkerStatusFilter> onStatusFilterChanged;
  final VoidCallback? onAddWorkerPressed;

  @override
  State<WorkerFilterBar> createState() => _WorkerFilterBarState();
}

class _WorkerFilterBarState extends State<WorkerFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void didUpdateWidget(WorkerFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter.searchQuery != widget.filter.searchQuery &&
        _searchController.text != widget.filter.searchQuery) {
      _searchController.text = widget.filter.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search workers by name…',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                widget.onSearchChanged('');
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (!isCompact && widget.onAddWorkerPressed != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: widget.onAddWorkerPressed,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Worker'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: WorkerStatusFilter.values.map((status) {
                  final isSelected = widget.filter.statusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(status.label),
                      onSelected: (_) => widget.onStatusFilterChanged(status),
                      selectedColor: theme.colorScheme.primaryContainer,
                      checkmarkColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
