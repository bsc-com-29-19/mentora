//
import 'package:flutter/material.dart';

class GraphBar extends StatelessWidget {
  final double value;
  final String label;
  final String day;

  const GraphBar(
      {required this.value, required this.label, required this.day, super.key});

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
        Text(day, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
      ],
    );
  }
}
