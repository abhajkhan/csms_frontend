import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/site_model.dart';
import '../../models/site_supervisor_model.dart';
import '../providers/site_providers.dart';

class SiteDetailsData {
  const SiteDetailsData({
    required this.site,
    required this.supervisors,
  });

  final SiteModel site;
  final List<SiteSupervisorModel> supervisors;

  SiteDetailsData copyWith({
    SiteModel? site,
    List<SiteSupervisorModel>? supervisors,
  }) =>
      SiteDetailsData(
        site: site ?? this.site,
        supervisors: supervisors ?? this.supervisors,
      );
}

class SiteDetailsController
    extends FamilyAsyncNotifier<SiteDetailsData, int> {
  @override
  Future<SiteDetailsData> build(int arg) async {
    final repository = ref.read(siteRepositoryProvider);
    final site = await repository.fetchSiteById(arg);
    final supervisors = await repository.fetchAssignedSupervisors(arg);
    return SiteDetailsData(site: site, supervisors: supervisors);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(siteRepositoryProvider);
      final site = await repository.fetchSiteById(arg);
      final supervisors = await repository.fetchAssignedSupervisors(arg);
      return SiteDetailsData(site: site, supervisors: supervisors);
    });
  }

  Future<bool> assignSupervisor(int supervisorId, {String? supervisorName}) async {
    final repository = ref.read(siteRepositoryProvider);
    try {
      await repository.assignSupervisor(arg, supervisorId, supervisorName: supervisorName);
      await refresh();
      ref.read(siteListControllerProvider.notifier).refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deactivateSupervisor(int supervisorId) async {
    final repository = ref.read(siteRepositoryProvider);
    try {
      await repository.deactivateSupervisorAssignment(arg, supervisorId);
      await refresh();
      ref.read(siteListControllerProvider.notifier).refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
