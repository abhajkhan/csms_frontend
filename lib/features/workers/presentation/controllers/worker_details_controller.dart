import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/worker.dart';
import '../providers/worker_providers.dart';

class WorkerDetailsController
    extends FamilyAsyncNotifier<Worker, int> {
  @override
  Future<Worker> build(int arg) async {
    final repository = ref.read(workerRepositoryProvider);
    return repository.fetchWorkerById(arg);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workerRepositoryProvider);
      return repository.fetchWorkerById(arg);
    });
  }

  Future<bool> toggleStatus({required bool isActive}) async {
    final repository = ref.read(workerRepositoryProvider);
    try {
      final updated = await repository.toggleWorkerStatus(arg, isActive: isActive);
      state = AsyncData(updated);
      ref.read(workerListControllerProvider.notifier).refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
