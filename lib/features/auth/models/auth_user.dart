enum UserRole {
  admin,
  supervisor,
  driver;

  factory UserRole.fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'supervisor':
        return UserRole.supervisor;
      case 'driver':
        return UserRole.driver;
      default:
        throw ArgumentError('Unknown user role: $role');
    }
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  final String id;
  final String name;
  final String username;
  final UserRole role;
}
