import 'package:flutter/material.dart';

import '../../../../shared/widgets/loading_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CSMS', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            const LoadingWidget(label: 'Checking your session…'),
          ],
        ),
      ),
    ),
  );
}
