import '../../auth/models/auth_user.dart';

enum UserStatusFilter {
  all,
  active,
  inactive;

  String get label => switch (this) {
    UserStatusFilter.all => 'All Status',
    UserStatusFilter.active => 'Active Only',
    UserStatusFilter.inactive => 'Inactive Only',
  };

  bool? toIsActiveQuery() => switch (this) {
    UserStatusFilter.all => null,
    UserStatusFilter.active => true,
    UserStatusFilter.inactive => false,
  };
}

enum UserRoleFilter {
  all,
  admin,
  supervisor,
  driver;

  String get label => switch (this) {
    UserRoleFilter.all => 'All Roles',
    UserRoleFilter.admin => 'Admin',
    UserRoleFilter.supervisor => 'Supervisor',
    UserRoleFilter.driver => 'Driver',
  };

  UserRole? toUserRole() => switch (this) {
    UserRoleFilter.all => null,
    UserRoleFilter.admin => UserRole.admin,
    UserRoleFilter.supervisor => UserRole.supervisor,
    UserRoleFilter.driver => UserRole.driver,
  };
}

class UserFilter {
  const UserFilter({
    this.searchQuery = '',
    this.roleFilter = UserRoleFilter.all,
    this.statusFilter = UserStatusFilter.all,
    this.page = 1,
    this.pageSize = 20,
  });

  final String searchQuery;
  final UserRoleFilter roleFilter;
  final UserStatusFilter statusFilter;
  final int page;
  final int pageSize;

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };

    if (searchQuery.trim().isNotEmpty) {
      params['search'] = searchQuery.trim();
    }

    final role = roleFilter.toUserRole();
    if (role != null) {
      params['role'] = role.name;
    }

    final isActive = statusFilter.toIsActiveQuery();
    if (isActive != null) {
      params['is_active'] = isActive;
    }

    return params;
  }

  UserFilter copyWith({
    String? searchQuery,
    UserRoleFilter? roleFilter,
    UserStatusFilter? statusFilter,
    int? page,
    int? pageSize,
  }) =>
      UserFilter(
        searchQuery: searchQuery ?? this.searchQuery,
        roleFilter: roleFilter ?? this.roleFilter,
        statusFilter: statusFilter ?? this.statusFilter,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );
}
