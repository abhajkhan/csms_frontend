import '../../../auth/models/auth_user.dart';

class UserCreateRequestDto {
  const UserCreateRequestDto({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.role,
  });

  final String fullName;
  final String phone;
  final String password;
  final UserRole role;

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'password': password,
    'role': role.name,
  };
}

class UserUpdateRequestDto {
  const UserUpdateRequestDto({
    this.fullName,
    this.phone,
  });

  final String? fullName;
  final String? phone;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    return data;
  }
}
