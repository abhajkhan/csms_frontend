import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/models/auth_user.dart';
import '../../data/dto/user_request_dto.dart';
import '../../models/user_model.dart';
import '../providers/user_providers.dart';

class UserFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Idle state
  }

  Future<UserModel?> createUser({
    required String fullName,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    UserModel? createdUser;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      createdUser = await repository.createUser(
        UserCreateRequestDto(
          fullName: fullName,
          phone: phone,
          password: password,
          role: role,
        ),
      );
      ref.read(userListControllerProvider.notifier).refresh();
    });

    if (state.hasError) return null;
    return createdUser;
  }

  Future<UserModel?> updateUser({
    required int userId,
    required String fullName,
    required String phone,
  }) async {
    UserModel? updatedUser;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      updatedUser = await repository.updateUser(
        userId,
        UserUpdateRequestDto(
          fullName: fullName,
          phone: phone,
        ),
      );
      ref.read(userListControllerProvider.notifier).refresh();
      ref.invalidate(userDetailsControllerProvider(userId));
    });

    if (state.hasError) return null;
    return updatedUser;
  }
}
