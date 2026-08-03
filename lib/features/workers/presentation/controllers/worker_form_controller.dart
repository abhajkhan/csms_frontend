import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dto/worker_request_dto.dart';
import '../../models/worker.dart';
import '../providers/worker_providers.dart';

class WorkerFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state is idle (AsyncData(null))
  }

  Future<Worker?> createWorker({
    required String fullName,
    required double dailyWage,
    bool isActive = true,
  }) async {
    Worker? createdWorker;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workerRepositoryProvider);
      createdWorker = await repository.createWorker(
        CreateWorkerRequestDto(
          fullName: fullName,
          dailyWage: dailyWage,
          isActive: isActive,
        ),
      );
      ref.read(workerListControllerProvider.notifier).refresh();
    });

    if (state.hasError) return null;
    return createdWorker;
  }

  Future<Worker?> updateWorker({
    required int workerId,
    required String fullName,
    required double dailyWage,
    required bool isActive,
  }) async {
    Worker? updatedWorker;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workerRepositoryProvider);
      updatedWorker = await repository.updateWorker(
        workerId,
        UpdateWorkerRequestDto(
          fullName: fullName,
          dailyWage: dailyWage,
          isActive: isActive,
        ),
      );
      ref.read(workerListControllerProvider.notifier).refresh();
      ref.invalidate(workerDetailsControllerProvider(workerId));
    });

    if (state.hasError) return null;
    return updatedWorker;
  }
}
