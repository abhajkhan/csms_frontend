import 'package:flutter/material.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../models/site_filter.dart';

class SiteFilterBar extends StatefulWidget {
  const SiteFilterBar({
    super.key,
    required this.filter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    this.onAddSitePressed,
  });

  final SiteFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<SiteStatusFilter> onStatusFilterChanged;
  final VoidCallback? onAddSitePressed;

  @override
  State<SiteFilterBar> createState() => _SiteFilterBarState();
}

class _SiteFilterBarState extends State<SiteFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void didUpdateWidget(SiteFilterBar oldWidget) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search sites by name or location…',
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
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
            if (widget.onAddSitePressed != null) ...[
              const SizedBox(width: 12),
              AppPrimaryButton(
                label: 'Add Site',
                icon: Icons.add_location_alt_outlined,
                onPressed: widget.onAddSitePressed,
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: SiteStatusFilter.values.map((status) {
              final isSelected = widget.filter.statusFilter == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(status.label),
                  selected: isSelected,
                  onSelected: (_) => widget.onStatusFilterChanged(status),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
