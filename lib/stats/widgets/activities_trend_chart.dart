import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'graphbar.dart';

class ActivitiesTrendChart extends StatelessWidget {
  const ActivitiesTrendChart({required this.activitiesData, super.key});

  final List<Map<String, dynamic>> activitiesData;

  @override
  Widget build(BuildContext context) {
    final sortedActivitiesData = List<Map<String, dynamic>>.from(activitiesData)
      ..sort((a, b) {
        final aDate = DateTime.parse(a['date']);
        final bDate = DateTime.parse(b['date']);
        return bDate.compareTo(aDate);
      });

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedActivitiesData.length,
        itemBuilder: (context, index) {
          final day = sortedActivitiesData[index];

          final completed = day['completed_activities'] as int? ?? 0;
          final incomplete = day['incomplete_activities'] as int? ?? 0;

          final totalActivities = completed + incomplete;

          final activitiesPercentage =
              totalActivities > 0 ? (completed / totalActivities) * 100 : 0.0;

          final dayAbbreviation =
              DateFormat('EEE').format(DateTime.parse(day['date']));

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Add horizontal spacing
            child: GraphBar(
              value: activitiesPercentage,
              label: "${activitiesPercentage.toStringAsFixed(1)}%",
              day: dayAbbreviation,
            ),
          );
        },
      ),
    );
  }
}
