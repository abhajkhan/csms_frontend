import 'package:csms_frontend/app/app.dart';
import 'package:csms_frontend/app/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('starts at the login route', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const CsmsApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('CSMS'), findsOneWidget);
  });
}
