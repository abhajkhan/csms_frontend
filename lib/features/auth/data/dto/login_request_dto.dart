class LoginRequestDto {
  const LoginRequestDto({required this.phone, required this.password});

  final String phone;
  final String password;

  Map<String, dynamic> toJson() => {'phone': phone, 'password': password};
}
