import 'package:csms_frontend/core/network/api_client.dart';
import 'package:csms_frontend/features/auth/models/auth_user.dart';
import 'package:csms_frontend/features/users/data/dto/user_request_dto.dart';
import 'package:csms_frontend/features/users/data/dto/user_response_dto.dart';
import 'package:csms_frontend/features/users/data/mapper/user_mapper.dart';
import 'package:csms_frontend/features/users/data/repository/user_repository.dart';
import 'package:csms_frontend/features/users/models/user_filter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserMapper Tests', () {
    test('converts UserResponseDto to UserModel correctly', () {
      const dto = UserResponseDto(
        userId: 10,
        role: UserRole.supervisor,
        fullName: 'Test User',
        phone: '+91 99999 88888',
        isActive: true,
        accBalance: 5000.0,
      );

      final model = UserMapper.toModel(dto);

      expect(model.id, 10);
      expect(model.fullName, 'Test User');
      expect(model.phone, '+91 99999 88888');
      expect(model.role, UserRole.supervisor);
      expect(model.isActive, isTrue);
      expect(model.formattedBalance, '₹5000.00');
    });
  });

  group('UserRepository Tests', () {
    late UserRepository repository;

    setUp(() {
      repository = UserRepository(ApiClient(Dio()));
    });

    test('fetchUsers returns mock data when API is offline', () async {
      final result = await repository.fetchUsers(const UserFilter());
      expect(result.items.isNotEmpty, isTrue);
      expect(result.total, greaterThanOrEqualTo(1));
    });

    test('createUser adds new user model correctly', () async {
      const request = UserCreateRequestDto(
        fullName: 'New Supervisor',
        phone: '+91 77777 66666',
        password: 'Password123',
        role: UserRole.supervisor,
      );

      final created = await repository.createUser(request);

      expect(created.fullName, 'New Supervisor');
      expect(created.phone, '+91 77777 66666');
      expect(created.role, UserRole.supervisor);
      expect(created.isActive, isTrue);
    });

    test('deactivateUser sets isActive to false', () async {
      final success = await repository.deactivateUser(2);
      expect(success, isTrue);

      final user = await repository.fetchUserById(2);
      expect(user.isActive, isFalse);
    });

    test('activateUser sets isActive to true', () async {
      final success = await repository.activateUser(2);
      expect(success, isTrue);

      final user = await repository.fetchUserById(2);
      expect(user.isActive, isTrue);
    });
  });
}
