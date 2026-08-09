import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ChangePasswordController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial idle state
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    });

    return !state.hasError;
  }

  String? get errorMessage {
    if (!state.hasError) return null;
    final error = state.error;
    if (error is ApiException) {
      return error.message;
    }
    return 'Unable to change password. Please check your current password and try again.';
  }
}
