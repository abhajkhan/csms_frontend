import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Attendance',
    child: PlaceholderPageBody(moduleName: 'Attendance'),
  );
}
