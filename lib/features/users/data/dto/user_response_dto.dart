import '../../../auth/models/auth_user.dart';

class UserResponseDto {
  const UserResponseDto({
    required this.userId,
    required this.role,
    required this.fullName,
    required this.phone,
    required this.isActive,
    this.driverType,
    this.accBalance,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    final rawBalance = json['acc_balance'] ?? json['accBalance'];
    double? balance;
    if (rawBalance is num) {
      balance = rawBalance.toDouble();
    } else if (rawBalance is String) {
      balance = double.tryParse(rawBalance);
    }

    final roleStr = (json['role'] ?? 'supervisor') as String;
    UserRole userRole;
    try {
      userRole = UserRole.fromString(roleStr);
    } catch (_) {
      userRole = UserRole.supervisor;
    }

    return UserResponseDto(
      userId: (json['user_id'] ?? json['id'] ?? 0) as int,
      role: userRole,
      fullName: (json['full_name'] ?? json['fullName'] ?? json['name'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      isActive: (json['is_active'] ?? json['isActive'] ?? true) as bool,
      driverType: json['driver_type'] as String?,
      accBalance: balance,
    );
  }

  final int userId;
  final UserRole role;
  final String fullName;
  final String phone;
  final bool isActive;
  final String? driverType;
  final double? accBalance;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'role': role.name,
    'full_name': fullName,
    'phone': phone,
    'is_active': isActive,
    if (driverType != null) 'driver_type': driverType,
    if (accBalance != null) 'acc_balance': accBalance,
  };
}

class UserListResponseDto {
  const UserListResponseDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory UserListResponseDto.fromJson(dynamic json) {
    if (json is List) {
      final items = json
          .whereType<Map<String, dynamic>>()
          .map(UserResponseDto.fromJson)
          .toList();
      return UserListResponseDto(
        items: items,
        total: items.length,
        page: 1,
        pageSize: items.isEmpty ? 20 : items.length,
        totalPages: 1,
      );
    }

    if (json is Map<String, dynamic>) {
      final rawItems = json['items'] ?? json['data'] ?? json['users'] ?? [];
      final List<UserResponseDto> items;
      if (rawItems is List) {
        items = rawItems
            .whereType<Map<String, dynamic>>()
            .map(UserResponseDto.fromJson)
            .toList();
      } else {
        items = [];
      }

      final total = (json['total'] ?? items.length) as int;
      final page = (json['page'] ?? 1) as int;
      final pageSize = (json['page_size'] ?? json['pageSize'] ?? 20) as int;
      final totalPages = (json['total_pages'] ?? json['totalPages'] ?? 1) as int;

      return UserListResponseDto(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
        totalPages: totalPages,
      );
    }

    return const UserListResponseDto(
      items: [],
      total: 0,
      page: 1,
      pageSize: 20,
      totalPages: 1,
    );
  }

  final List<UserResponseDto> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
}
