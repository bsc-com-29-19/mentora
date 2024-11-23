import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/journal/screens/journal_screen.dart';
import 'package:mentora_frontend/journal/viewmodel/journal_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({
    'username': 'testUser',
    'email': 'testuser@example.com',
    'fullName': 'Test User',
  });

  late JournalController journalController;

  setUp(() {
    journalController = JournalController();
    Get.put(journalController);
  });

  tearDown(() {
    Get.delete<JournalController>();
  });

  testWidgets('Scroll to interactable widgets in JournalScreen', (WidgetTester tester) async {
    // Build the JournalScreen within a MaterialApp
    await tester.pumpWidget(
      GetMaterialApp(
        home: const JournalScreen(),
      ),
    );

    // Wait for the widget to fully render
    await tester.pumpAndSettle();

    // Verify that the ListView is present
    expect(find.byType(ListView), findsOneWidget);

    // Scroll down
    await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);
    await tester.pumpAndSettle(); // Wait for the scroll animation to complete

    // Verify some elements are present after scrolling
    expect(find.byType(ListTile), findsWidgets);
    
    // Scroll back up
    await tester.fling(find.byType(ListView), const Offset(0, 500), 1000);
    await tester.pumpAndSettle();

    // Verify the first item is visible
    expect(find.text('Item 0'), findsOneWidget);
  });
}