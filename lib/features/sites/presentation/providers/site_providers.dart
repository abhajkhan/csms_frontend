import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../data/repository/site_repository.dart';
import '../controllers/site_details_controller.dart';
import '../controllers/site_form_controller.dart';
import '../controllers/site_list_controller.dart';
import '../states/site_list_state.dart';

final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SiteRepository(apiClient);
});

final siteListControllerProvider =
    AsyncNotifierProvider<SiteListController, SiteListState>(
      SiteListController.new,
    );

final siteDetailsControllerProvider = AsyncNotifierProviderFamily<
  SiteDetailsController,
  SiteDetailsData,
  int
>(SiteDetailsController.new);

final siteFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<SiteFormController, void>(
      SiteFormController.new,
    );
