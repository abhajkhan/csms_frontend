import 'package:flutter/material.dart';

import '../components/app_card.dart';

class PlaceholderPageBody extends StatelessWidget {
  const PlaceholderPageBody({super.key, required this.moduleName});

  final String moduleName;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(moduleName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'This module foundation is ready for feature implementation.',
            ),
          ],
        ),
      ),
    ),
  );
}
