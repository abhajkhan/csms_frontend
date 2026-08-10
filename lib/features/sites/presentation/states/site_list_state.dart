import '../../models/site_filter.dart';
import '../../models/site_model.dart';

class SiteListState {
  const SiteListState({
    required this.sites,
    required this.totalCount,
    required this.filter,
    this.isActionLoading = false,
    this.actionError,
  });

  final List<SiteModel> sites;
  final int totalCount;
  final SiteFilter filter;
  final bool isActionLoading;
  final String? actionError;

  bool get isEmpty => sites.isEmpty;

  SiteListState copyWith({
    List<SiteModel>? sites,
    int? totalCount,
    SiteFilter? filter,
    bool? isActionLoading,
    String? actionError,
  }) =>
      SiteListState(
        sites: sites ?? this.sites,
        totalCount: totalCount ?? this.totalCount,
        filter: filter ?? this.filter,
        isActionLoading: isActionLoading ?? this.isActionLoading,
        actionError: actionError,
      );
}
