import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class SitesPage extends StatelessWidget {
  const SitesPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Sites',
    child: PlaceholderPageBody(moduleName: 'Sites'),
  );
}
