import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    late SharedPreferences prefs;

    setUp(() async {
      // Initialize GetX test mode
      Get.testMode = true;
      
      // Set up shared preferences
      SharedPreferences.setMockInitialValues({
        'username': 'testuser',
        'email': 'test@example.com',
        'fullName': 'Test User',
        'isAuthenticated': true,
      });
      prefs = await SharedPreferences.getInstance();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('ProfileScreen displays user information', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        GetMaterialApp(
          home: ProfileScreen(),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => ProfileScreen()),
            GetPage(name: '/signin', page: () => Scaffold(body: Text('Sign In'))),
          ],
        ),
      );

      // Wait for async operations to complete
      await tester.pump(Duration(milliseconds: 100));

      // Verify that user information is displayed
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('ProfileScreen handles unauthenticated state', (WidgetTester tester) async {
      // Reset shared preferences to unauthenticated state
      SharedPreferences.setMockInitialValues({
        'username': '',
        'email': '',
        'fullName': '',
        'isAuthenticated': false,
      });
      prefs = await SharedPreferences.getInstance();

      // Build our app and trigger a frame
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => ProfileScreen()),
            GetPage(name: '/signin', page: () => Scaffold(body: Text('Sign In'))),
          ],
        ),
      );

      // Wait for loading indicator
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait a short time for navigation
      await tester.pump(Duration(milliseconds: 100));
      
      // Verify navigation to signin page
      await tester.pump();
      expect(find.text('Sign In'), findsOneWidget);
    });

    test('handleLogout clears user data', () async {
      // Set up GetX
      Get.testMode = true;
      
      // Setup initial values
      SharedPreferences.setMockInitialValues({
        'username': 'testuser',
        'email': 'test@example.com',
        'fullName': 'Test User',
        'token': 'test-token',
        'isAuthenticated': true,
      });
      prefs = await SharedPreferences.getInstance();

      // Create a widget to provide navigation context
      final widget = GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => ProfileScreen()),
          GetPage(name: '/signin', page: () => Scaffold(body: Text('Sign In'))),
        ],
      );
      
      // Initialize navigation
      await runInTest(() async {
        Get.put(widget);
      });

      // Call logout
      await ProfileScreen.handleLogout();

      // Verify preferences were cleared
      expect(await prefs.getString('username'), null);
      expect(await prefs.getString('email'), null);
      expect(await prefs.getString('fullName'), null);
      expect(await prefs.getString('token'), null);
      expect(await prefs.getBool('isAuthenticated'), false);
      expect(await prefs.getBool('onBoardingCompleted'), true);
    });
  });
}

// Helper function to run widget initialization in test environment
Future<void> runInTest(Future<void> Function() testFn) async {
  return TestAsyncUtils.guard<void>(() async {
    await testFn();
  });
}