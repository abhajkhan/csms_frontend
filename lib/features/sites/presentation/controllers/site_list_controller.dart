import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dto/site_request_dto.dart';
import '../../models/site_filter.dart';
import '../../models/site_model.dart';
import '../providers/site_providers.dart';
import '../states/site_list_state.dart';

class SiteListController extends AsyncNotifier<SiteListState> {
  @override
  Future<SiteListState> build() async {
    return _fetch(const SiteFilter());
  }

  Future<SiteListState> _fetch(SiteFilter filter) async {
    final repository = ref.read(siteRepositoryProvider);
    final result = await repository.fetchSites(filter);
    return SiteListState(
      sites: result.items,
      totalCount: result.total,
      filter: filter,
    );
  }

  Future<void> search(String query) async {
    final currentFilter = state.valueOrNull?.filter ?? const SiteFilter();
    final newFilter = currentFilter.copyWith(searchQuery: query, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> setStatusFilter(SiteStatusFilter statusFilter) async {
    final currentFilter = state.valueOrNull?.filter ?? const SiteFilter();
    final newFilter = currentFilter.copyWith(statusFilter: statusFilter, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> changePage(int newPage) async {
    final currentFilter = state.valueOrNull?.filter ?? const SiteFilter();
    final newFilter = currentFilter.copyWith(page: newPage);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> refresh() async {
    final currentFilter = state.valueOrNull?.filter ?? const SiteFilter();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(currentFilter));
  }

  Future<bool> updateSiteStatus(int siteId, SiteStatus status) async {
    final repository = ref.read(siteRepositoryProvider);
    try {
      if (status == SiteStatus.completed) {
        await repository.archiveSite(siteId);
      } else {
        await repository.updateSite(
          siteId,
          UpdateSiteRequestDto(status: status),
        );
      }
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
