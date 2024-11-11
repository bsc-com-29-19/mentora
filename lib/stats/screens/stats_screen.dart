import 'package:flutter/material.dart';

void main() {
  runApp(MentoraApp());
}

class MentoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentora',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: StatsScreen(),
      
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Summary: Last 30 days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                StatCard(label: 'Activities completion', value: '0 %'),
                StatCard(label: 'Average self rating', value: '0 / 5'),
                StatCard(label: 'Incomplete Activities', value: '23'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Mood Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: MoodTrendChart(),
            ),
          ],
        ),
      ),
      
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        MoodBar(value: 76, label: '26.4%'),
        MoodBar(value: 95, label: '33.0%'),
        MoodBar(value: 36, label: '12.5%'),
        MoodBar(value: 81, label: '28.1%'),
      ],
    );
  }
}

class MoodBar extends StatelessWidget {
  final double value;
  final String label;

  const MoodBar({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: value / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}


