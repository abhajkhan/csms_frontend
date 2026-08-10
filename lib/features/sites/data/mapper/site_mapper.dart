import '../../models/site_model.dart';
import '../../models/site_supervisor_model.dart';
import '../dto/site_response_dto.dart';
import '../dto/site_supervisor_dto.dart';

abstract final class SiteMapper {
  static SiteModel toSiteModel(SiteResponseDto dto) => SiteModel(
    id: dto.siteId,
    name: dto.siteName,
    location: dto.location,
    status: dto.status,
    createdAt: dto.createdAt,
    createdBy: dto.createdBy,
  );

  static List<SiteModel> toSiteModelList(List<SiteResponseDto> dtos) =>
      dtos.map(toSiteModel).toList();

  static SiteSupervisorModel toSupervisorModel(SiteSupervisorResponseDto dto) =>
      SiteSupervisorModel(
        id: dto.id,
        siteId: dto.siteId,
        supervisorId: dto.supervisorId,
        assignedAt: dto.assignedAt,
        isActive: dto.isActive,
        supervisorName: dto.supervisorName,
        supervisorPhone: dto.supervisorPhone,
      );

  static List<SiteSupervisorModel> toSupervisorModelList(
    List<SiteSupervisorResponseDto> dtos,
  ) =>
      dtos.map(toSupervisorModel).toList();
}
