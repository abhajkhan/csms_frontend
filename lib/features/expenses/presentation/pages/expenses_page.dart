import 'package:flutter/material.dart';
import '../../../../shared/layouts/page_scaffold.dart';
import '../../../../shared/widgets/placeholder_page_body.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPageScaffold(
    title: 'Expenses',
    child: PlaceholderPageBody(moduleName: 'Expenses'),
  );
}
