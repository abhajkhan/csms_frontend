import 'package:flutter/material.dart';
import '../widgets/change_password_card.dart';
import '../widgets/logout_card.dart';
import '../widgets/profile_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileCard(),
                SizedBox(height: 20),
                ChangePasswordCard(),
                SizedBox(height: 20),
                LogoutCard(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
