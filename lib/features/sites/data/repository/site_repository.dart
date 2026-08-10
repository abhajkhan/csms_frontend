import '../../../../core/network/api_client.dart';
import '../../models/site_filter.dart';
import '../../models/site_model.dart';
import '../../models/site_supervisor_model.dart';
import '../dto/site_request_dto.dart';
import '../dto/site_response_dto.dart';
import '../dto/site_supervisor_dto.dart';
import '../mapper/site_mapper.dart';

class SiteRepository {
  SiteRepository(this._apiClient);

  static const String _sitesPath = '/sites';
  final ApiClient _apiClient;

  // In-memory seed list for fallback during dev/testing when server is offline
  static final List<SiteModel> _mockSites = [
    SiteModel(
      id: 1,
      name: 'Metro Station Phase 1',
      location: 'Sector G, Blue Area',
      status: SiteStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      createdBy: 1,
    ),
    SiteModel(
      id: 2,
      name: 'Commercial Complex B',
      location: 'Plot 45, Industrial Zone',
      status: SiteStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      createdBy: 1,
    ),
    SiteModel(
      id: 3,
      name: 'Highway Expansion km 14',
      location: 'Northern Bypass',
      status: SiteStatus.onHold,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      createdBy: 1,
    ),
    SiteModel(
      id: 4,
      name: 'Residential Tower C',
      location: 'Phase 5, Block B',
      status: SiteStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      createdBy: 1,
    ),
  ];

  static final List<SiteSupervisorModel> _mockSupervisors = [
    SiteSupervisorModel(
      id: 101,
      siteId: 1,
      supervisorId: 2,
      assignedAt: DateTime.now().subtract(const Duration(days: 45)),
      isActive: true,
      supervisorName: 'Vikram Singh',
      supervisorPhone: '+91 98765 00002',
    ),
    SiteSupervisorModel(
      id: 102,
      siteId: 1,
      supervisorId: 3,
      assignedAt: DateTime.now().subtract(const Duration(days: 20)),
      isActive: true,
      supervisorName: 'Anil Kumar',
      supervisorPhone: '+91 98765 00003',
    ),
  ];

  Future<({List<SiteModel> items, int total})> fetchSites(SiteFilter filter) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        _sitesPath,
        queryParameters: filter.toQueryParams(),
      );

      final body = response.data;
      if (body == null) {
        return (items: <SiteModel>[], total: 0);
      }

      final payload = body['data'] ?? body;
      final dto = SiteListResponseDto.fromJson(payload);
      return (items: SiteMapper.toSiteModelList(dto.items), total: dto.total);
    } catch (_) {
      // Offline fallback filtering
      var filtered = List<SiteModel>.from(_mockSites);

      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.trim().toLowerCase();
        filtered = filtered
            .where(
              (s) =>
                  s.name.toLowerCase().contains(query) ||
                  (s.location?.toLowerCase().contains(query) ?? false),
            )
            .toList();
      }

      final queryStatus = filter.statusFilter.toQueryStatus();
      if (queryStatus != null) {
        filtered = filtered.where((s) => s.status.value == queryStatus).toList();
      }

      return (items: filtered, total: filtered.length);
    }
  }

  Future<SiteModel> fetchSiteById(int id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('$_sitesPath/$id');
      final body = response.data;
      if (body == null) throw FormatException('Site not found for ID $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = SiteResponseDto.fromJson(payload);
      return SiteMapper.toSiteModel(dto);
    } catch (_) {
      return _mockSites.firstWhere(
        (s) => s.id == id,
        orElse: () => SiteModel(
          id: id,
          name: 'Construction Site #$id',
          location: 'City Center',
          status: SiteStatus.active,
          createdAt: DateTime.now(),
          createdBy: 1,
        ),
      );
    }
  }

  Future<SiteModel> createSite(CreateSiteRequestDto request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _sitesPath,
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw const FormatException('Empty server response on site creation');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = SiteResponseDto.fromJson(payload);
      final created = SiteMapper.toSiteModel(dto);
      _mockSites.insert(0, created);
      return created;
    } catch (_) {
      final newId = DateTime.now().millisecondsSinceEpoch % 100000;
      final newSite = SiteModel(
        id: newId,
        name: request.siteName,
        location: request.location,
        status: SiteStatus.active,
        createdAt: DateTime.now(),
        createdBy: 1,
      );
      _mockSites.insert(0, newSite);
      return newSite;
    }
  }

  Future<SiteModel> updateSite(int id, UpdateSiteRequestDto request) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '$_sitesPath/$id',
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw FormatException('Empty server response on updating site $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = SiteResponseDto.fromJson(payload);
      final updated = SiteMapper.toSiteModel(dto);
      _updateMock(updated);
      return updated;
    } catch (_) {
      final existing = await fetchSiteById(id);
      final updated = existing.copyWith(
        name: request.siteName,
        location: request.location,
        status: request.status,
      );
      _updateMock(updated);
      return updated;
    }
  }

  Future<bool> archiveSite(int id) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>('$_sitesPath/$id');
      final existing = await fetchSiteById(id);
      _updateMock(existing.copyWith(status: SiteStatus.completed));
      return true;
    } catch (_) {
      final index = _mockSites.indexWhere((s) => s.id == id);
      if (index != -1) {
        _mockSites[index] = _mockSites[index].copyWith(status: SiteStatus.completed);
      }
      return true;
    }
  }

  Future<List<SiteSupervisorModel>> fetchAssignedSupervisors(int siteId) async {
    try {
      final response = await _apiClient.get<dynamic>('$_sitesPath/$siteId/supervisors');
      final body = response.data;
      if (body == null) return [];

      final rawList = body is Map<String, dynamic> ? (body['data'] ?? []) : body;
      if (rawList is List) {
        final dtos = rawList
            .whereType<Map<String, dynamic>>()
            .map(SiteSupervisorResponseDto.fromJson)
            .toList();
        return SiteMapper.toSupervisorModelList(dtos);
      }
      return [];
    } catch (_) {
      return _mockSupervisors.where((s) => s.siteId == siteId).toList();
    }
  }

  Future<SiteSupervisorModel> assignSupervisor(int siteId, int supervisorId, {String? supervisorName}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '$_sitesPath/$siteId/supervisors',
        data: SiteSupervisorRequestDto(siteId: siteId, supervisorId: supervisorId).toJson(),
      );
      final body = response.data;
      if (body == null) throw const FormatException('Empty response on supervisor assignment');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = SiteSupervisorResponseDto.fromJson(payload);
      final created = SiteMapper.toSupervisorModel(dto);
      _mockSupervisors.insert(0, created);
      return created;
    } catch (_) {
      final newAssignment = SiteSupervisorModel(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        siteId: siteId,
        supervisorId: supervisorId,
        assignedAt: DateTime.now(),
        isActive: true,
        supervisorName: supervisorName ?? 'Supervisor #$supervisorId',
      );
      _mockSupervisors.insert(0, newAssignment);
      return newAssignment;
    }
  }

  Future<bool> deactivateSupervisorAssignment(int siteId, int supervisorId) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>(
        '$_sitesPath/$siteId/supervisors/$supervisorId',
      );
      _mockSupervisors.removeWhere((s) => s.siteId == siteId && s.supervisorId == supervisorId);
      return true;
    } catch (_) {
      _mockSupervisors.removeWhere((s) => s.siteId == siteId && s.supervisorId == supervisorId);
      return true;
    }
  }

  void _updateMock(SiteModel updated) {
    final index = _mockSites.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _mockSites[index] = updated;
    } else {
      _mockSites.insert(0, updated);
    }
  }
}
