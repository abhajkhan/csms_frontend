import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../providers/user_providers.dart';

class UserDetailsController extends FamilyAsyncNotifier<UserModel, int> {
  @override
  Future<UserModel> build(int arg) async {
    final repository = ref.read(userRepositoryProvider);
    return repository.fetchUserById(arg);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      return repository.fetchUserById(arg);
    });
  }

  Future<bool> activate() async {
    final repository = ref.read(userRepositoryProvider);
    try {
      final success = await repository.activateUser(arg);
      if (success) {
        final updated = await repository.fetchUserById(arg);
        state = AsyncData(updated);
        ref.read(userListControllerProvider.notifier).refresh();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deactivate() async {
    final repository = ref.read(userRepositoryProvider);
    try {
      final success = await repository.deactivateUser(arg);
      if (success) {
        final updated = await repository.fetchUserById(arg);
        state = AsyncData(updated);
        ref.read(userListControllerProvider.notifier).refresh();
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}
