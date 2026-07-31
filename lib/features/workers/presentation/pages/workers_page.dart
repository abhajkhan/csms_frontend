import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Workers',
    child: PlaceholderPageBody(moduleName: 'Workers'),
  );
}
