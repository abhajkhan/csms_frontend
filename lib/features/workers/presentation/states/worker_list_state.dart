import '../../models/worker.dart';
import '../../models/worker_filter.dart';

class WorkerListState {
  const WorkerListState({
    required this.workers,
    required this.totalCount,
    required this.filter,
    this.isActionLoading = false,
    this.actionError,
  });

  final List<Worker> workers;
  final int totalCount;
  final WorkerFilter filter;
  final bool isActionLoading;
  final String? actionError;

  bool get isEmpty => workers.isEmpty;

  WorkerListState copyWith({
    List<Worker>? workers,
    int? totalCount,
    WorkerFilter? filter,
    bool? isActionLoading,
    String? actionError,
  }) => WorkerListState(
    workers: workers ?? this.workers,
    totalCount: totalCount ?? this.totalCount,
    filter: filter ?? this.filter,
    isActionLoading: isActionLoading ?? this.isActionLoading,
    actionError: actionError,
  );
}
