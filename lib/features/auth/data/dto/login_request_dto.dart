class LoginRequestDto {
  const LoginRequestDto({required this.usernameOrPhone, required this.password});

  final String usernameOrPhone;
  final String password;

  Map<String, dynamic> toJson() => {
    'username_or_phone': usernameOrPhone,
    'password': password,
  };
}
