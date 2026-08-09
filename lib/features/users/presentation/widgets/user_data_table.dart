import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'user_role_badge.dart';
import 'user_status_badge.dart';

class UserDataTable extends StatelessWidget {
  const UserDataTable({
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
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Wallet Balance', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text('#${user.id}')),
                DataCell(
                  InkWell(
                    onTap: () => onViewDetails(user),
                    child: Text(
                      user.fullName,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(UserRoleBadge(role: user.role)),
                DataCell(Text(user.phone)),
                DataCell(Text(user.formattedBalance)),
                DataCell(UserStatusBadge(isActive: user.isActive)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        tooltip: 'View Details',
                        onPressed: () => onViewDetails(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Edit Profile',
                        onPressed: () => onEdit(user),
                      ),
                      IconButton(
                        icon: Icon(
                          user.isActive
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 20,
                          color: user.isActive
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                        tooltip: user.isActive ? 'Deactivate' : 'Activate',
                        onPressed: () => onToggleStatus(user),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
