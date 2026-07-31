import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Settings',
    child: PlaceholderPageBody(moduleName: 'Settings'),
  );
}
