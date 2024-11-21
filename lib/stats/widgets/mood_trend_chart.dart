import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'graphbar.dart';

class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({required this.moodData, super.key});

  final List<Map<String, dynamic>> moodData;

  @override
  Widget build(BuildContext context) {
    final sortedMoodData = List<Map<String, dynamic>>.from(moodData)
      ..sort((a, b) {
        final aDate = DateTime.parse(a['date']);
        final bDate = DateTime.parse(b['date']);
        return bDate.compareTo(aDate);
      });

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedMoodData.length,
        itemBuilder: (context, index) {
          final day = sortedMoodData[index];

          final moodRating = (day['mood_rating'] as int? ?? 0).toDouble();

          final dayAbbreviation =
              DateFormat('EEE').format(DateTime.parse(day['date']));

          final moodPercentage = (moodRating / 5) * 100;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Add horizontal spacing
            child: GraphBar(
              value: moodPercentage,
              label: "${moodPercentage.toStringAsFixed(1)}%",
              day: dayAbbreviation,
            ),
          );
        },
      ),
    );
  }
}
