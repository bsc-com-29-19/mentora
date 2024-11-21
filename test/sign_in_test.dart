import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentora_frontend/auth/screens/signin_screen.dart';

void main() {
  group('SigninScreen', () {
    testWidgets('contains Scaffold with white background color',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SigninScreen()));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(Scaffold)) as Scaffold)
              .backgroundColor,
          Colors.white);
    });

    testWidgets('contains Form with TextFormField for email or username',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SigninScreen()));
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Email or Username'), findsOneWidget);
    });

    testWidgets('contains TextFormField for password', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SigninScreen()));
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('contains TextButton with text "Forgot Password?"',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SigninScreen()));
      expect(find.byType(TextButton), findsWidgets);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('contains TextButton with text "Sign Up"', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SigninScreen()));
      expect(find.byType(TextButton), findsWidgets);
      expect(find.text('Sign Up'), findsOneWidget);
    });
  });
}
