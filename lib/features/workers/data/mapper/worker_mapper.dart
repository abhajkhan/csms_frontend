import '../../models/worker.dart';
import '../dto/worker_response_dto.dart';

abstract final class WorkerMapper {
  static Worker toModel(WorkerResponseDto dto) => Worker(
    id: dto.workerId,
    fullName: dto.fullName,
    dailyWage: dto.dailyWage,
    isActive: dto.isActive,
    createdBy: dto.createdBy,
    phone: dto.phone,
    address: dto.address,
    skill: dto.skill,
    assignedSite: dto.assignedSite,
  );

  static List<Worker> toModelList(List<WorkerResponseDto> dtos) =>
      dtos.map(toModel).toList();
}
