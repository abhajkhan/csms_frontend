class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final tokenSource = json['tokens'] is Map<String, dynamic>
        ? json['tokens'] as Map<String, dynamic>
        : json;
    final user = json['user'];
    if (user is! Map<String, dynamic>) {
      throw const FormatException('Login response does not contain a user.');
    }
    final accessToken = tokenSource['access_token'] ?? tokenSource['accessToken'];
    final refreshToken = tokenSource['refresh_token'] ?? tokenSource['refreshToken'];
    if (accessToken is! String || refreshToken is! String) {
      throw const FormatException('Login response does not contain JWT tokens.');
    }
    return AuthResponseDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }
}
