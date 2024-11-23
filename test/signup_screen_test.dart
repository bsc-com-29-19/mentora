import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mentora_frontend/auth/screens/signup_screen.dart';

void main() {
  testWidgets('Sign Up Screen has all required fields', (WidgetTester tester) async {
    // Pump the widget
    await tester.pumpWidget(GetMaterialApp(home: const SignUpScreen()));

    // Wait for animations and the widget tree to settle
    await tester.pumpAndSettle();

    // Verify Full Name Field
    expect(find.byKey(const Key('fullNameField')), findsOneWidget);

    // Verify Username Field
    expect(find.byKey(const Key('usernameField')), findsOneWidget);

    // Verify Email Field
    expect(find.byKey(const Key('emailField')), findsOneWidget);

    // Verify Password Field
    expect(find.byKey(const Key('passwordField')), findsOneWidget);

    // Verify Sign Up Button
    expect(find.byKey(const Key('signUpButton')), findsOneWidget);
  });
}
