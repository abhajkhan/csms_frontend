import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_filter.dart';
import '../providers/user_providers.dart';
import '../states/user_list_state.dart';

class UserListController extends AsyncNotifier<UserListState> {
  @override
  Future<UserListState> build() async {
    return _fetch(const UserFilter());
  }

  Future<UserListState> _fetch(UserFilter filter) async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.fetchUsers(filter);
    return UserListState(
      users: result.items,
      totalCount: result.total,
      filter: filter,
    );
  }

  Future<void> search(String query) async {
    final currentFilter = state.valueOrNull?.filter ?? const UserFilter();
    final newFilter = currentFilter.copyWith(searchQuery: query, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> setRoleFilter(UserRoleFilter roleFilter) async {
    final currentFilter = state.valueOrNull?.filter ?? const UserFilter();
    final newFilter = currentFilter.copyWith(roleFilter: roleFilter, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> setStatusFilter(UserStatusFilter statusFilter) async {
    final currentFilter = state.valueOrNull?.filter ?? const UserFilter();
    final newFilter = currentFilter.copyWith(statusFilter: statusFilter, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> changePage(int newPage) async {
    final currentFilter = state.valueOrNull?.filter ?? const UserFilter();
    final newFilter = currentFilter.copyWith(page: newPage);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(newFilter));
  }

  Future<void> refresh() async {
    final currentFilter = state.valueOrNull?.filter ?? const UserFilter();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(currentFilter));
  }

  Future<bool> activateUser(int userId) async {
    final repository = ref.read(userRepositoryProvider);
    try {
      await repository.activateUser(userId);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deactivateUser(int userId) async {
    final repository = ref.read(userRepositoryProvider);
    try {
      await repository.deactivateUser(userId);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
