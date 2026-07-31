import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Reports',
    child: PlaceholderPageBody(moduleName: 'Reports'),
  );
}
