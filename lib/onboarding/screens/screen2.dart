import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset("assets/images/image_2.png"),
        Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              radius: 154,
              lineWidth: 10,
              backgroundColor: Colors.green.shade300,
              progressColor: Colors.white,
              percent: .7,
            ),
            ClipOval(
              child: Image.asset(
                "assets/images/image_2.png",
                width: 290,
                height: 290,
                fit: BoxFit.cover,
              ),

              // child: Image.network("assets/images/image_1.png"),
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          "Therapist Bot At Your Side",
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Get guided support & counselling with our AI Therapist.",
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
