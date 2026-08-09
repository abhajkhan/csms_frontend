import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../models/auth_state.dart';
import '../providers/auth_providers.dart';

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    ref.listen(sessionInvalidationProvider, (previous, next) {
      state = const AsyncData(AuthState.unauthenticated());
    });

    try {
      final accessToken = await tokenStorage.readAccessToken();
      final refreshToken = await tokenStorage.readRefreshToken();
      if (accessToken == null || accessToken.isEmpty) {
        if (refreshToken == null || refreshToken.isEmpty) {
          return const AuthState.unauthenticated();
        }
        final tokens = await ref
            .read(authRepositoryProvider)
            .refresh(refreshToken);
        await tokenStorage.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
      }
      final user = await ref.read(authRepositoryProvider).currentUser();
      return AuthState.authenticated(user);
    } catch (_) {
      await tokenStorage.clear();
      return const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String phone, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final tokens = await ref
          .read(authRepositoryProvider)
          .login(phone: phone, password: password);
      await ref
          .read(tokenStorageProvider)
          .saveTokens(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
          );
      try {
        final user = await ref.read(authRepositoryProvider).currentUser();
        return AuthState.authenticated(user);
      } catch (_) {
        await ref.read(tokenStorageProvider).clear();
        rethrow;
      }
    });
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // The contract defines logout as client-side invalidation. Clearing local
      // credentials is therefore required even if the network request fails.
    }
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(AuthState.unauthenticated());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
