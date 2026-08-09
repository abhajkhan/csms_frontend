import '../../models/user_filter.dart';
import '../../models/user_model.dart';

class UserListState {
  const UserListState({
    required this.users,
    required this.totalCount,
    required this.filter,
    this.isActionLoading = false,
    this.actionError,
  });

  final List<UserModel> users;
  final int totalCount;
  final UserFilter filter;
  final bool isActionLoading;
  final String? actionError;

  bool get isEmpty => users.isEmpty;

  UserListState copyWith({
    List<UserModel>? users,
    int? totalCount,
    UserFilter? filter,
    bool? isActionLoading,
    String? actionError,
  }) =>
      UserListState(
        users: users ?? this.users,
        totalCount: totalCount ?? this.totalCount,
        filter: filter ?? this.filter,
        isActionLoading: isActionLoading ?? this.isActionLoading,
        actionError: actionError,
      );
}
