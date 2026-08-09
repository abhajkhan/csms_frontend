import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../data/repository/user_repository.dart';
import '../../models/user_model.dart';
import '../controllers/user_details_controller.dart';
import '../controllers/user_form_controller.dart';
import '../controllers/user_list_controller.dart';
import '../states/user_list_state.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});

final userListControllerProvider =
    AsyncNotifierProvider<UserListController, UserListState>(
      UserListController.new,
    );

final userDetailsControllerProvider = AsyncNotifierProviderFamily<
  UserDetailsController,
  UserModel,
  int
>(UserDetailsController.new);

final userFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<UserFormController, void>(
      UserFormController.new,
    );
