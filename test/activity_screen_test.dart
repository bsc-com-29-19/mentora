import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/activity/screens/activity_screen.dart';
import 'package:mentora_frontend/activity/viewmodels/activities_view_model.dart';
import 'package:mentora_frontend/activity/widgets/activity_card.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';

void main() {
  group('ActivitiesScreen', () {
    testWidgets('returns Scaffold with AppBar', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: ActivitiesScreen(),
        ),
      );
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    // testWidgets('AppBar has title with correct text and style', (tester) async {
    //   await tester.pumpWidget(
    //     GetMaterialApp(
    //       home: ActivitiesScreen(),
    //     ),
    //   );
    //   final title = find.byType(Text).evaluate().single.widget as Text;
    //   expect(title.data, 'Activities');
    //   expect(title.style?.color, Colors.black);
    //   expect(title.style?.fontWeight, FontWeight.bold);
    //   expect(title.style?.fontSize, 24);
    // });

    testWidgets('AccountIconButton is displayed with correct username, email, and fullName', (tester) async {
      final activitiesController = Get.put(ActivitiesController());
      activitiesController.username.value = 'username';
      activitiesController.email.value = 'email@example.com';
      activitiesController.fullName.value = 'Full Name';

      await tester.pumpWidget(
        GetMaterialApp(
          home: ActivitiesScreen(),
        ),
      );
      final accountIconButton = find.byType(AccountIconButton).evaluate().single.widget as AccountIconButton;
      expect(accountIconButton.username, 'username');
      expect(accountIconButton.email, 'email@example.com');
      expect(accountIconButton.fullName, 'Full Name');
    });

    testWidgets('CircularProgressIndicator is displayed when isLoading is true', (tester) async {
      final activitiesController = Get.put(ActivitiesController());
      activitiesController.isLoading.value = true;

      await tester.pumpWidget(
        GetMaterialApp(
          home: ActivitiesScreen(),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // testWidgets('error message is displayed when errorMessage is not empty', (tester) async {
    //   final activitiesController = Get.put(ActivitiesController());
    //   activitiesController.errorMessage.value = 'Error message';

    //   await tester.pumpWidget(
    //     GetMaterialApp(
    //       home: ActivitiesScreen(),
    //     ),
    //   );
    //   expect(find.byType(Text), findsOneWidget);
    //   final errorMessage = find.byType(Text).evaluate().single.widget as Text;
    //   expect(errorMessage.data, 'Error message');
    //   expect(errorMessage.style?.color, Colors.red);
    // });

    testWidgets('activities list is displayed when isLoading is false and errorMessage is empty', (tester) async {
      final activitiesController = Get.put(ActivitiesController());
      activitiesController.isLoading.value = false;
      activitiesController.errorMessage.value = '';

      await tester.pumpWidget(
        GetMaterialApp(
          home: ActivitiesScreen(),
        ),
      );
      expect(find.byType(ListView), findsOneWidget);
    });

    // testWidgets('activities list displays correct number of completed activities', (tester) async {
    //   final activitiesController = Get.put(ActivitiesController());
    //   activitiesController.isLoading.value = false;
    //   activitiesController.errorMessage.value = '';
    //   activitiesController.activities.value = [
    //     {'id': '1', 'title': 'Activity 1', 'status': 'done'},
    //     {'id': '2', 'title': 'Activity 2', 'status': 'not_done'},
    //     {'id': '3', 'title': 'Activity 3', 'status': 'done'},
    //   ];

    //   await tester.pumpWidget(
    //     GetMaterialApp(
    //       home: ActivitiesScreen(),
    //     ),
    //   );
    //   final completedActivitiesText = find.byType(Text).evaluate().single.widget as Text;
    //   expect(completedActivitiesText.data, '2/3 Completed');
    // });

    testWidgets('ActivityCard is displayed for each activity', (tester) async {
      final activitiesController = Get.put(ActivitiesController());
      activitiesController.isLoading.value = false;
      activitiesController.errorMessage.value = '';
      activitiesController.activities.value = [
        {'id': '1', 'title': 'Activity 1', 'status': 'done'},
        {'id': '2', 'title': 'Activity 2', 'status': 'not_done'}];

      await tester.pumpWidget(
        GetMaterialApp(
          home: ActivitiesScreen(),
        ),
      );
      expect(find.byType(ActivityCard), findsNWidgets(2));
    });
  });
}

