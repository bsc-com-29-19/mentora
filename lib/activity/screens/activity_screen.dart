import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/activity/viewmodels/activities_view_model.dart';
import 'package:mentora_frontend/activity/widgets/activity_card.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
// import 'package:mentora_frontend/controllers/activities_controller.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final ActivitiesController _activitiesController =
      Get.put(ActivitiesController());

  void toggleActivityStatus(String activityId, String currentStatus) {
    final newStatus = currentStatus == 'done' ? 'not_done' : 'done';
    _activitiesController.updateActivityStatus(activityId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Activities",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Obx(() {
            return AccountIconButton(
              username: _activitiesController.username.value,
              email: _activitiesController.email.value,
              fullName: _activitiesController.fullName.value,
              onLogout: ProfileScreen.handleLogout,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_activitiesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_activitiesController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              _activitiesController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        final totalActivities = _activitiesController.activities.length;
        final completedCount = _activitiesController.activities
            .where((activity) => activity['status'] == 'done')
            .length;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${DateTime.now().toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '$completedCount/$totalActivities Completed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _activitiesController.activities.length,
                itemBuilder: (context, index) {
                  final activity = _activitiesController.activities[index];
                  return ActivityCard(
                    title: activity['title'],
                    completed: activity['status'] == 'done',
                    onChanged: (value) => toggleActivityStatus(
                        activity['id'], activity['status']),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
