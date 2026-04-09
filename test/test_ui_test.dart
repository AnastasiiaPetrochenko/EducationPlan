import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:ui_lab_3/screens/auth/login_screen.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    setupFirebaseCoreMocks();

    await Firebase.initializeApp();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_auth'),
      (MethodCall methodCall) async => null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/google_sign_in'),
      (MethodCall methodCall) async => null,
    );
  });

  group('LoginScreen — Високорівневі UI тести', () {
    
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: LoginScreen(),
      );
    }

    testWidgets('1. Відображення основних елементів інтерфейсу', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Education Plan'), findsOneWidget);
      expect(find.text('Увійдіть у свій акаунт'), findsOneWidget);

      expect(find.text('Увійти'), findsOneWidget);
      expect(find.text('Увійти через Google'), findsOneWidget);
      expect(find.text('Зареєструватися'), findsOneWidget);
    });

    testWidgets('2. Валідація форми: порожні поля', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Увійти'));
      await tester.pumpAndSettle();

      expect(find.text('Будь ласка, введіть email'), findsOneWidget);
      expect(find.text('Будь ласка, введіть пароль'), findsOneWidget);
    });

    testWidgets('3. Валідація форми: некоректний email та короткий пароль', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), 'bad-email-format');
      await tester.enterText(textFields.at(1), '123');

      await tester.tap(find.text('Увійти'));
      await tester.pumpAndSettle();

      expect(find.text('Введіть коректний email'), findsOneWidget);
      expect(find.text('Пароль має бути не менше 6 символів'), findsOneWidget);
    });

    testWidgets('4. Інтерактивність: зміна видимості пароля', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final passwordFieldFinder = find.byType(TextField).at(1); 
      TextField passwordField = tester.widget(passwordFieldFinder);
      
      expect(passwordField.obscureText, true); 

      final visibilityIcon = find.byIcon(Icons.visibility); 
      
      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle(); 

      passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, false); 
    });
  });
}