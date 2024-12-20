import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          color: Colors.grey.shade900, // Background color
        ),
        margin:
            const EdgeInsets.symmetric(horizontal: 8.0), // Margin between cards
        child: Card(
          elevation: 8,
          child: ExpansionTile(
            title: Column(
              children: [
                Text(
                  value, 
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  label, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
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
