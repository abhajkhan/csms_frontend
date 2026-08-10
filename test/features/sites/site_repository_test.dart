import 'package:csms_frontend/core/network/api_client.dart';
import 'package:csms_frontend/features/sites/data/dto/site_request_dto.dart';
import 'package:csms_frontend/features/sites/data/dto/site_response_dto.dart';
import 'package:csms_frontend/features/sites/data/mapper/site_mapper.dart';
import 'package:csms_frontend/features/sites/data/repository/site_repository.dart';
import 'package:csms_frontend/features/sites/models/site_filter.dart';
import 'package:csms_frontend/features/sites/models/site_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SiteMapper Tests', () {
    test('converts SiteResponseDto to SiteModel correctly', () {
      final now = DateTime.now();
      final dto = SiteResponseDto(
        siteId: 5,
        siteName: 'Test Metro Site',
        location: 'Sector 9',
        status: SiteStatus.active,
        createdAt: now,
        createdBy: 1,
      );

      final model = SiteMapper.toSiteModel(dto);

      expect(model.id, 5);
      expect(model.name, 'Test Metro Site');
      expect(model.location, 'Sector 9');
      expect(model.status, SiteStatus.active);
      expect(model.createdBy, 1);
    });
  });

  group('SiteRepository Tests', () {
    late SiteRepository repository;

    setUp(() {
      repository = SiteRepository(ApiClient(Dio()));
    });

    test('fetchSites returns mock items when server is offline', () async {
      final result = await repository.fetchSites(const SiteFilter());

      expect(result.items.isNotEmpty, isTrue);
      expect(result.total, greaterThanOrEqualTo(1));
    });

    test('createSite creates new site correctly', () async {
      const request = CreateSiteRequestDto(
        siteName: 'New Bridge Construction',
        location: 'River Zone',
      );

      final site = await repository.createSite(request);

      expect(site.name, 'New Bridge Construction');
      expect(site.location, 'River Zone');
      expect(site.status, SiteStatus.active);
    });

    test('updateSite updates site name and status', () async {
      const request = UpdateSiteRequestDto(
        siteName: 'Updated Commercial Site',
        status: SiteStatus.onHold,
      );

      final site = await repository.updateSite(1, request);

      expect(site.name, 'Updated Commercial Site');
      expect(site.status, SiteStatus.onHold);
    });

    test('archiveSite sets site status to completed', () async {
      final success = await repository.archiveSite(1);
      expect(success, isTrue);

      final site = await repository.fetchSiteById(1);
      expect(site.status, SiteStatus.completed);
    });

    test('assignSupervisor and fetchAssignedSupervisors work as expected', () async {
      final assigned = await repository.assignSupervisor(1, 10, supervisorName: 'Test Sup');
      expect(assigned.siteId, 1);
      expect(assigned.supervisorId, 10);

      final list = await repository.fetchAssignedSupervisors(1);
      expect(list.any((s) => s.supervisorId == 10), isTrue);

      final removed = await repository.deactivateSupervisorAssignment(1, 10);
      expect(removed, isTrue);
    });
  });
}
