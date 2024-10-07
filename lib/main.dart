import 'package:flutter/material.dart';
import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
import 'package:mentora_frontend/onboarding/screens/screen1.dart';
import 'package:mentora_frontend/onboarding/screens/screen2.dart';
import 'package:mentora_frontend/onboarding/screens/screen3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:mentora_frontend/common/widgets/navigation_menu.dart';

// Todo : Make onboarding one time step after app installation not onAppOpen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mentora',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Mentora Home Page'));
    // home: const NavigationMenu());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  String buttonText = "Skip";
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green.shade300,
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                currentPageIndex = index;
                if (index == 2) {
                  buttonText = "Finish";
                } else {
                  buttonText = "Skip";
                }
                setState(() {});
              },
              children: const [Screen1(), Screen2(), Screen3()],
            ),
            Container(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigationMenu()));
                    },
                    //Todo : make it bold and change color
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) => pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    effect: const WormEffect(activeDotColor: Colors.white),
                  ),
                  currentPageIndex == 2
                      ? const SizedBox(
                          width: 10,
                        )
                      : GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeIn);
                          },

                          //Todo : make it bold and change color
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                ],
              ),
            )
          ],
        ));
  }
}
