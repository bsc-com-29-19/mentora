import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
import 'package:mentora_frontend/stats/viewmodels/stats_view_model.dart';
import 'package:mentora_frontend/stats/widgets/activities_trend_chart.dart';
import 'package:mentora_frontend/stats/widgets/mood_trend_chart.dart';
import 'package:mentora_frontend/stats/widgets/stats_card.dart';

class StatsScreen extends StatelessWidget {
  final StatsController statsController = Get.put(StatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Obx(() {
            return AccountIconButton(
              username: statsController.username.value,
              email: statsController.email.value,
              fullName: statsController.fullName.value,
              onLogout: ProfileScreen.handleLogout,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (statsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (statsController.errorMessage.isNotEmpty) {
          return Center(child: Text(statsController.errorMessage.value));
        }

        // Safely fetch stats values
        final completionPercentage =
            statsController.getCompletionPercentage().toStringAsFixed(1);
        final allDaysTrends = statsController.getAllDaysTrends();
        final allDaysTrendsTyped = allDaysTrends.cast<Map<String, dynamic>>();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Summary: Last 30 Days',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  StatCardExpandable(
                    label: 'Activities completion',
                    value: '${statsController.getCompletionPercentage()}%',
                    details: 'Completion details for the week.',
                  ),
                  StatCardExpandable(
                    label: 'Incomplete Activities',
                    value: '${statsController.calculateIncompleteActivities()}',
                    details: 'Details about incomplete activities.',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Mood Trend',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: MoodTrendChart(moodData: allDaysTrendsTyped),
              ),
              const SizedBox(height: 32),
              const Text(
                'Activities Trend',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ActivitiesTrendChart(activitiesData: allDaysTrendsTyped),
              ),
            ],
          ),
        );
      }),
    );
  }
}
