import 'package:flutter/material.dart';

void main() {
  runApp(MentoraApp());
}

// Root widget for the application
class MentoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentora',
      theme: ThemeData(
        brightness: Brightness.dark, // Set the theme to dark mode
      ),
      home: StatsScreen(), // Set the StatsScreen as the home screen
    );
  }
}

// Main screen widget that displays the stats summary and mood trend
class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title for the summary section
            const Text(
              'Summary: Last 30 days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), // Spacing below the title
            // Row containing the expandable stat cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                // Each card displays a stat with expandable details
                StatCardExpandable(
                  label: 'Activities completion',
                  value: '0 %',
                  details: 'Details about Activities completion',
                ),
                StatCardExpandable(
                  label: 'Average self rating',
                  value: '0 / 5',
                  details: 'Details about Average self rating',
                ),
                StatCardExpandable(
                  label: 'Incomplete Activities',
                  value: '23',
                  details: 'Details about Incomplete Activities',
                ),
              ],
            ),
            const SizedBox(height: 32), // Spacing below the stat cards
            // Title for the mood trend section
            const Text(
              'Mood Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), // Spacing below the mood trend title
            // Mood trend chart
            Expanded(
              child: MoodTrendChart(),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget representing an expandable stat card with details
class StatCardExpandable extends StatelessWidget {
  final String label; // Label for the stat
  final String value; // Main value displayed on the card
  final String details; // Additional details shown when expanded

  const StatCardExpandable({
    super.key,
    required this.label,
    required this.value,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // Box decoration for the card container
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          color: Colors.grey.shade900, // Background color
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4.0), // Margin between cards
        child: Card(
          elevation: 2,
          // Expansion tile allows the card to be expandable
          child: ExpansionTile(
            title: Column(
              children: [
                Text(
                  value, // Display the main value
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  label, // Display the label
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            // Additional details shown when expanded
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(details),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget representing the mood trend chart with vertical bars
class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        // Each MoodBar represents a data point in the mood trend chart
        MoodBar(value: 76, label: '26.4%'),
        MoodBar(value: 95, label: '33.0%'),
        MoodBar(value: 36, label: '12.5%'),
        MoodBar(value: 81, label: '28.1%'),
      ],
    );
  }
}

// Widget representing a single bar in the mood trend chart
class MoodBar extends StatelessWidget {
  final double value; // Value of the mood bar (percentage)
  final String label; // Label shown below the bar

  const MoodBar({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // Container for the bar itself
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey, // Bar background color
              borderRadius: BorderRadius.circular(4), // Rounded corners for the bar
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: value / 100, // Scale the bar height based on value
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade300, // Bar fill color
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4), // Space between bar and label
        Text(label, style: const TextStyle(fontSize: 12)), // Display the label
      ],
    );
  }
}
