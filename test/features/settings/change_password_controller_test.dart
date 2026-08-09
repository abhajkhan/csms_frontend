import 'package:csms_frontend/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordController Tests', () {
    test('initial state completes build without error', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(changePasswordControllerProvider.future);
      final state = container.read(changePasswordControllerProvider);
      expect(state.hasError, isFalse);
    });
  });
}
