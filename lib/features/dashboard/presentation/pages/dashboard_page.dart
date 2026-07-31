import 'package:flutter/material.dart';

import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Dashboard',
    child: PlaceholderPageBody(moduleName: 'Dashboard'),
  );
}
