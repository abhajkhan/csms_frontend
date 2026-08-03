import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/worker_filter.dart';
import '../providers/worker_providers.dart';
import '../states/worker_list_state.dart';

class WorkerListController extends AsyncNotifier<WorkerListState> {
  @override
  Future<WorkerListState> build() async {
    return _fetch(const WorkerFilter());
  }

  Future<WorkerListState> _fetch(WorkerFilter filter) async {
    final repository = ref.read(workerRepositoryProvider);
    final result = await repository.fetchWorkers(filter);
    return WorkerListState(
      workers: result.items,
      totalCount: result.total,
      filter: filter,
    );
  }

  Future<void> search(String query) async {
    final current = state.valueOrNull;
    final currentFilter = current?.filter ?? const WorkerFilter();
    final newFilter = currentFilter.copyWith(searchQuery: query, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> setStatusFilter(WorkerStatusFilter statusFilter) async {
    final current = state.valueOrNull;
    final currentFilter = current?.filter ?? const WorkerFilter();
    final newFilter = currentFilter.copyWith(statusFilter: statusFilter, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> changePage(int newPage) async {
    final current = state.valueOrNull;
    final currentFilter = current?.filter ?? const WorkerFilter();
    final newFilter = currentFilter.copyWith(page: newPage);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> refresh() async {
    final currentFilter = state.valueOrNull?.filter ?? const WorkerFilter();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(currentFilter));
  }

  Future<bool> toggleWorkerStatus(int workerId, {required bool isActive}) async {
    final repository = ref.read(workerRepositoryProvider);
    try {
      await repository.toggleWorkerStatus(workerId, isActive: isActive);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteWorker(int workerId) async {
    final repository = ref.read(workerRepositoryProvider);
    try {
      await repository.deleteWorker(workerId);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
