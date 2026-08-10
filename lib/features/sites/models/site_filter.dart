enum SiteStatusFilter {
  all,
  active,
  completed,
  onHold;

  String get label => switch (this) {
    SiteStatusFilter.all => 'All Sites',
    SiteStatusFilter.active => 'Active',
    SiteStatusFilter.completed => 'Completed',
    SiteStatusFilter.onHold => 'On Hold',
  };

  String? toQueryStatus() => switch (this) {
    SiteStatusFilter.all => null,
    SiteStatusFilter.active => 'active',
    SiteStatusFilter.completed => 'completed',
    SiteStatusFilter.onHold => 'on_hold',
  };
}

class SiteFilter {
  const SiteFilter({
    this.searchQuery = '',
    this.statusFilter = SiteStatusFilter.all,
    this.page = 1,
    this.pageSize = 20,
  });

  final String searchQuery;
  final SiteStatusFilter statusFilter;
  final int page;
  final int pageSize;

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };

    if (searchQuery.trim().isNotEmpty) {
      params['search'] = searchQuery.trim();
    }

    final status = statusFilter.toQueryStatus();
    if (status != null) {
      params['status'] = status;
    }

    return params;
  }

  SiteFilter copyWith({
    String? searchQuery,
    SiteStatusFilter? statusFilter,
    int? page,
    int? pageSize,
  }) =>
      SiteFilter(
        searchQuery: searchQuery ?? this.searchQuery,
        statusFilter: statusFilter ?? this.statusFilter,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );
}
