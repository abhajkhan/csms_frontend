import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../models/auth_state.dart';
import '../../models/auth_user.dart';
import '../../models/jwt_token.dart';
import '../providers/auth_providers.dart';

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final token = await tokenStorage.readAccessToken();
    if (token == null || JwtToken.isExpired(token)) {
      if (token != null) await tokenStorage.clear();
      return const AuthState.unauthenticated();
    }

    try {
      final claims = JwtToken.decodeClaims(token);
      return AuthState.authenticated(_userFromClaims(claims));
    } on FormatException {
      await tokenStorage.clear();
      return const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(usernameOrPhone: usernameOrPhone, password: password);
      if (JwtToken.isExpired(session.tokens.accessToken)) {
        throw const FormatException(
          'The server returned an expired access token.',
        );
      }
      await ref
          .read(tokenStorageProvider)
          .saveTokens(
            accessToken: session.tokens.accessToken,
            refreshToken: session.tokens.refreshToken,
          );
      return AuthState.authenticated(session.user);
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(AuthState.unauthenticated());
  }

  AuthUser _userFromClaims(Map<String, dynamic> claims) => AuthUser(
    id: claims['sub']?.toString() ?? claims['user_id']?.toString() ?? '',
    name: claims['name']?.toString() ?? '',
    username: claims['username']?.toString() ?? '',
    role: claims['role']?.toString() ?? '',
  );
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
