enum WorkerStatusFilter {
  all,
  active,
  inactive;

  String get label => switch (this) {
    WorkerStatusFilter.all => 'All Status',
    WorkerStatusFilter.active => 'Active Only',
    WorkerStatusFilter.inactive => 'Inactive Only',
  };

  bool? toIsActiveQuery() => switch (this) {
    WorkerStatusFilter.all => null,
    WorkerStatusFilter.active => true,
    WorkerStatusFilter.inactive => false,
  };
}

class WorkerFilter {
  const WorkerFilter({
    this.searchQuery = '',
    this.statusFilter = WorkerStatusFilter.all,
    this.page = 1,
    this.pageSize = 20,
  });

  final String searchQuery;
  final WorkerStatusFilter statusFilter;
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

    final isActive = statusFilter.toIsActiveQuery();
    if (isActive != null) {
      params['is_active'] = isActive;
    }

    return params;
  }

  WorkerFilter copyWith({
    String? searchQuery,
    WorkerStatusFilter? statusFilter,
    int? page,
    int? pageSize,
  }) => WorkerFilter(
    searchQuery: searchQuery ?? this.searchQuery,
    statusFilter: statusFilter ?? this.statusFilter,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
  );
}
