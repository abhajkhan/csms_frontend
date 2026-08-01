import '../../models/auth_session.dart';
import '../../models/auth_tokens.dart';
import '../../models/auth_user.dart';
import '../dto/auth_response_dto.dart';

class AuthMapper {
  const AuthMapper._();

  static AuthSession toSession(AuthResponseDto dto) => AuthSession(
    tokens: AuthTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    ),
    user: AuthUser(
      id: _requiredString(dto.user, 'id'),
      name: _optionalString(dto.user, 'name'),
      username: _optionalString(dto.user, 'username'),
      role: _optionalString(dto.user, 'role'),
    ),
  );

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.isNotEmpty) return value;
    if (value is num) return value.toString();
    throw FormatException('Login response user does not contain $key.');
  }

  static String _optionalString(Map<String, dynamic> json, String key) =>
      json[key]?.toString() ?? '';
}
