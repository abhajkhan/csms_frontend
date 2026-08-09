import '../../models/auth_tokens.dart';
import '../../models/auth_user.dart';
import '../dto/auth_response_dto.dart';

class AuthMapper {
  const AuthMapper._();

  static AuthTokens toTokens(AuthResponseDto dto) =>
      AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken);

  static AuthUser toUser(Map<String, dynamic> json) => AuthUser(
    id: _requiredString(json, 'user_id'),
    name: _requiredString(json, 'full_name'),
    username: _requiredString(json, 'phone'),
    role: UserRole.fromString(_requiredString(json, 'role')),
  );

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.isNotEmpty) return value;
    if (value is num) return value.toString();
    throw FormatException('Authentication response does not contain $key.');
  }
}
