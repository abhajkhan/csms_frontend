import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> requestOtp(String phone) => _run(
    () => ref.read(authRepositoryProvider).requestPasswordResetOtp(phone),
  );

  Future<void> verifyOtp({required String phone, required String otp}) => _run(
    () => ref.read(authRepositoryProvider).verifyPasswordResetOtp(
      phone: phone,
      otp: otp,
    ),
  );

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) => _run(
    () => ref.read(authRepositoryProvider).resetPassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    ),
  );

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, void>(
      ForgotPasswordController.new,
    );
