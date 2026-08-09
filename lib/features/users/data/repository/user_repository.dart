import '../../../../core/network/api_client.dart';
import '../../../auth/models/auth_user.dart';
import '../../models/user_filter.dart';
import '../../models/user_model.dart';
import '../dto/user_request_dto.dart';
import '../dto/user_response_dto.dart';
import '../mapper/user_mapper.dart';

class UserRepository {
  UserRepository(this._apiClient);

  static const String _usersPath = '/users';
  final ApiClient _apiClient;

  // In-memory seed list for fallback during dev/testing when server is offline
  static final List<UserModel> _mockUsers = [
    const UserModel(
      id: 1,
      fullName: 'System Administrator',
      phone: '+91 98765 00001',
      role: UserRole.admin,
      isActive: true,
      accBalance: 0.0,
    ),
    const UserModel(
      id: 2,
      fullName: 'Vikram Singh',
      phone: '+91 98765 00002',
      role: UserRole.supervisor,
      isActive: true,
      accBalance: 15000.0,
    ),
    const UserModel(
      id: 3,
      fullName: 'Anil Kumar',
      phone: '+91 98765 00003',
      role: UserRole.supervisor,
      isActive: true,
      accBalance: 8500.0,
    ),
    const UserModel(
      id: 4,
      fullName: 'Sunil Rao',
      phone: '+91 98765 00004',
      role: UserRole.driver,
      driverType: 'normal',
      isActive: true,
      accBalance: 2500.0,
    ),
    const UserModel(
      id: 5,
      fullName: 'Rajesh Sharma',
      phone: '+91 98765 00005',
      role: UserRole.driver,
      driverType: 'ajax',
      isActive: false,
      accBalance: 0.0,
    ),
  ];

  Future<({List<UserModel> items, int total})> fetchUsers(UserFilter filter) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        _usersPath,
        queryParameters: filter.toQueryParams(),
      );

      final body = response.data;
      if (body == null) {
        return (items: <UserModel>[], total: 0);
      }

      final payload = body['data'] ?? body;
      final dto = UserListResponseDto.fromJson(payload);
      return (items: UserMapper.toModelList(dto.items), total: dto.total);
    } catch (_) {
      // Offline fallback filtering
      var filtered = List<UserModel>.from(_mockUsers);

      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.trim().toLowerCase();
        filtered = filtered
            .where(
              (u) =>
                  u.fullName.toLowerCase().contains(query) ||
                  u.phone.toLowerCase().contains(query),
            )
            .toList();
      }

      final roleFilter = filter.roleFilter.toUserRole();
      if (roleFilter != null) {
        filtered = filtered.where((u) => u.role == roleFilter).toList();
      }

      final isActiveQuery = filter.statusFilter.toIsActiveQuery();
      if (isActiveQuery != null) {
        filtered = filtered.where((u) => u.isActive == isActiveQuery).toList();
      }

      return (items: filtered, total: filtered.length);
    }
  }

  Future<UserModel> fetchUserById(int id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('$_usersPath/$id');
      final body = response.data;
      if (body == null) throw FormatException('User not found for ID $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = UserResponseDto.fromJson(payload);
      return UserMapper.toModel(dto);
    } catch (_) {
      return _mockUsers.firstWhere(
        (u) => u.id == id,
        orElse: () => UserModel(
          id: id,
          fullName: 'User #$id',
          phone: '+91 98765 00000',
          role: UserRole.supervisor,
          isActive: true,
        ),
      );
    }
  }

  Future<UserModel> createUser(UserCreateRequestDto request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _usersPath,
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw const FormatException('Empty server response on user creation');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = UserResponseDto.fromJson(payload);
      final created = UserMapper.toModel(dto);
      _mockUsers.insert(0, created);
      return created;
    } catch (_) {
      final newId = DateTime.now().millisecondsSinceEpoch % 100000;
      final newUser = UserModel(
        id: newId,
        fullName: request.fullName,
        phone: request.phone,
        role: request.role,
        isActive: true,
        accBalance: 0.0,
      );
      _mockUsers.insert(0, newUser);
      return newUser;
    }
  }

  Future<UserModel> updateUser(int id, UserUpdateRequestDto request) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '$_usersPath/$id',
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw FormatException('Empty server response on updating user $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = UserResponseDto.fromJson(payload);
      final updated = UserMapper.toModel(dto);
      _updateMock(updated);
      return updated;
    } catch (_) {
      final existing = await fetchUserById(id);
      final updated = existing.copyWith(
        fullName: request.fullName,
        phone: request.phone,
      );
      _updateMock(updated);
      return updated;
    }
  }

  Future<bool> deactivateUser(int id) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>('$_usersPath/$id');
      final existing = await fetchUserById(id);
      _updateMock(existing.copyWith(isActive: false));
      return true;
    } catch (_) {
      final index = _mockUsers.indexWhere((u) => u.id == id);
      if (index != -1) {
        _mockUsers[index] = _mockUsers[index].copyWith(isActive: false);
      }
      return true;
    }
  }

  Future<bool> activateUser(int id) async {
    try {
      await _apiClient.patch<Map<String, dynamic>>('$_usersPath/$id/activate');
      final existing = await fetchUserById(id);
      _updateMock(existing.copyWith(isActive: true));
      return true;
    } catch (_) {
      final index = _mockUsers.indexWhere((u) => u.id == id);
      if (index != -1) {
        _mockUsers[index] = _mockUsers[index].copyWith(isActive: true);
      }
      return true;
    }
  }

  void _updateMock(UserModel updated) {
    final index = _mockUsers.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      _mockUsers[index] = updated;
    } else {
      _mockUsers.insert(0, updated);
    }
  }
}
