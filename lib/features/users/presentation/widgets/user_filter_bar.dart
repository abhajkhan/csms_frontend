import 'package:flutter/material.dart';
import '../../models/user_filter.dart';

class UserFilterBar extends StatefulWidget {
  const UserFilterBar({
    super.key,
    required this.filter,
    required this.onSearchChanged,
    required this.onRoleFilterChanged,
    required this.onStatusFilterChanged,
    this.onAddUserPressed,
  });

  final UserFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserRoleFilter> onRoleFilterChanged;
  final ValueChanged<UserStatusFilter> onStatusFilterChanged;
  final VoidCallback? onAddUserPressed;

  @override
  State<UserFilterBar> createState() => _UserFilterBarState();
}

class _UserFilterBarState extends State<UserFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void didUpdateWidget(UserFilterBar oldWidget) {
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
                      hintText: 'Search users by name or phone…',
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
                if (!isCompact && widget.onAddUserPressed != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: widget.onAddUserPressed,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add User'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Role: ',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...UserRoleFilter.values.map((role) {
                    final isSelected = widget.filter.roleFilter == role;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(role.label),
                        onSelected: (_) => widget.onRoleFilterChanged(role),
                        selectedColor: theme.colorScheme.primaryContainer,
                        checkmarkColor: theme.colorScheme.onPrimaryContainer,
                      ),
                    );
                  }),
                  const SizedBox(width: 16),
                  Text(
                    'Status: ',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...UserStatusFilter.values.map((status) {
                    final isSelected = widget.filter.statusFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(status.label),
                        onSelected: (_) => widget.onStatusFilterChanged(status),
                        selectedColor: theme.colorScheme.secondaryContainer,
                        checkmarkColor: theme.colorScheme.onSecondaryContainer,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
