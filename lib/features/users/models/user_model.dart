import '../../auth/models/auth_user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.isActive,
    this.driverType,
    this.accBalance,
  });

  final int id;
  final String fullName;
  final String phone;
  final UserRole role;
  final bool isActive;
  final String? driverType;
  final double? accBalance;

  String get roleLabel => switch (role) {
    UserRole.admin => 'Admin',
    UserRole.supervisor => 'Supervisor',
    UserRole.driver => 'Driver',
  };

  String get formattedBalance =>
      accBalance != null ? '₹${accBalance!.toStringAsFixed(2)}' : 'N/A';

  UserModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    UserRole? role,
    bool? isActive,
    String? driverType,
    double? accBalance,
  }) =>
      UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        driverType: driverType ?? this.driverType,
        accBalance: accBalance ?? this.accBalance,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          phone == other.phone &&
          role == other.role &&
          isActive == other.isActive &&
          driverType == other.driverType &&
          accBalance == other.accBalance;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      phone.hashCode ^
      role.hashCode ^
      isActive.hashCode ^
      driverType.hashCode ^
      accBalance.hashCode;
}
