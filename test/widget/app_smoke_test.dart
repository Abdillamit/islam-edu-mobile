import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islam_edu_mobile/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows onboarding first and opens app shell after continue', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'language_code': 'ru',
      'onboarding_completed': false,
      'device_id': 'test-device-id-123',
    });

    await tester.pumpWidget(const ProviderScope(child: IslamEduApp()));
    await tester.pumpAndSettle();

    expect(find.text('Добро пожаловать'), findsOneWidget);

    await tester.tap(find.text('Продолжить'));
    await tester.pumpAndSettle();

    expect(find.text('Главная'), findsWidgets);
  });
}
