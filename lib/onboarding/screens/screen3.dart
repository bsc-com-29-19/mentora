import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              radius: 154,
              lineWidth: 10,
              backgroundColor: Colors.green.shade300,
              progressColor: Colors.white,
              percent: 1,
            ),
            ClipOval(
              child: Image.asset(
                "assets/images/image_3.png",
                width: 290,
                height: 290,
                fit: BoxFit.cover,
              ),

            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          "Track Your Progress",
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Monitor your emotional journey through detailed mood trends and metrics.",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
