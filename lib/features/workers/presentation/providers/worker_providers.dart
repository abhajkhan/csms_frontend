import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../data/repository/worker_repository.dart';
import '../controllers/worker_details_controller.dart';
import '../controllers/worker_form_controller.dart';
import '../controllers/worker_list_controller.dart';
import '../states/worker_list_state.dart';
import '../../models/worker.dart';

final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkerRepository(apiClient);
});

final workerListControllerProvider =
    AsyncNotifierProvider<WorkerListController, WorkerListState>(
      WorkerListController.new,
    );

final workerDetailsControllerProvider = AsyncNotifierProviderFamily<
  WorkerDetailsController,
  Worker,
  int
>(WorkerDetailsController.new);

final workerFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<WorkerFormController, void>(
      WorkerFormController.new,
    );
