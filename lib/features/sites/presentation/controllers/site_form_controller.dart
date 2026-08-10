import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dto/site_request_dto.dart';
import '../../models/site_model.dart';
import '../providers/site_providers.dart';

class SiteFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Idle state
  }

  Future<SiteModel?> createSite({
    required String siteName,
    String? location,
  }) async {
    SiteModel? createdSite;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(siteRepositoryProvider);
      createdSite = await repository.createSite(
        CreateSiteRequestDto(siteName: siteName, location: location),
      );
      ref.read(siteListControllerProvider.notifier).refresh();
    });

    if (state.hasError) return null;
    return createdSite;
  }

  Future<SiteModel?> updateSite({
    required int siteId,
    required String siteName,
    String? location,
    SiteStatus? status,
  }) async {
    SiteModel? updatedSite;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(siteRepositoryProvider);
      updatedSite = await repository.updateSite(
        siteId,
        UpdateSiteRequestDto(
          siteName: siteName,
          location: location,
          status: status,
        ),
      );
      ref.read(siteListControllerProvider.notifier).refresh();
      ref.invalidate(siteDetailsControllerProvider(siteId));
    });

    if (state.hasError) return null;
    return updatedSite;
  }
}
