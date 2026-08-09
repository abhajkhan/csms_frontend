class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final refreshToken = json['refresh_token'];
    if (accessToken is! String || refreshToken is! String) {
      throw const FormatException(
        'Login response does not contain JWT tokens.',
      );
    }
    return AuthResponseDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
