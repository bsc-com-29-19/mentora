import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color; // Ensures customizable button colors

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.green, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures button stretches across the parent
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // backgroundColor: color, // Use the passed or default color
          backgroundColor: Colors.green.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Spacing for touch areas
          elevation: 4, // Adds subtle shadow for visual hierarchy
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16, // Comfortable font size for readability
            fontWeight: FontWeight.bold, // Emphasize button label
          ),
        ),
      ),
    );
  }
}
