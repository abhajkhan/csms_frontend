import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'user_card.dart';

class UserCardList extends StatelessWidget {
  const UserCardList({
    super.key,
    required this.users,
    required this.onViewDetails,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final List<UserModel> users;
  final ValueChanged<UserModel> onViewDetails;
  final ValueChanged<UserModel> onEdit;
  final ValueChanged<UserModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onTap: () => onViewDetails(user),
          onEdit: () => onEdit(user),
          onToggleStatus: () => onToggleStatus(user),
        );
      },
    );
  }
}
