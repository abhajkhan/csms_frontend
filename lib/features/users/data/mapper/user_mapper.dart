import '../../models/user_model.dart';
import '../dto/user_response_dto.dart';

abstract final class UserMapper {
  static UserModel toModel(UserResponseDto dto) => UserModel(
    id: dto.userId,
    fullName: dto.fullName,
    phone: dto.phone,
    role: dto.role,
    isActive: dto.isActive,
    driverType: dto.driverType,
    accBalance: dto.accBalance,
  );

  static List<UserModel> toModelList(List<UserResponseDto> dtos) =>
      dtos.map(toModel).toList();
}
