import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final bool completed;
  final ValueChanged<bool?> onChanged;

  const ActivityCard({
    super.key,
    required this.title,
    required this.completed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0), // Add padding to prevent the card from touching edges
      child: Container(
        padding:
            const EdgeInsets.all(16.0), // Inner padding for the card content
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Distribute space between text and checkbox
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Checkbox(
              value: completed,
              onChanged: onChanged,
              activeColor: Colors.white,
              checkColor: Colors.green.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
