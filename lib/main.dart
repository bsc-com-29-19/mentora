//main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mentora_frontend/auth/screens/signin_screen.dart';
import 'package:mentora_frontend/auth/screens/signup_screen.dart';
import 'package:mentora_frontend/common/widgets/navigation_menu.dart';

// import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
import 'package:mentora_frontend/onboarding/screens/screen1.dart';
import 'package:mentora_frontend/onboarding/screens/screen2.dart';
import 'package:mentora_frontend/onboarding/screens/screen3.dart';
import 'package:mentora_frontend/stats/viewmodels/stats_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// import 'package:mentora_frontend/common/widgets/navigation_menu.dart';

// Todo : Make onboarding one time step after app installation not onAppOpen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onBoardingCompleted =
      prefs.getBool('onBoardingCompleted') ?? false;

  final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

  runApp(MyApp(
    onBoardingCompleted: onBoardingCompleted,
    isAuthenticated: isAuthenticated,
  ));
}

class MyApp extends StatelessWidget {
  final bool onBoardingCompleted;
  final bool isAuthenticated;
  final StatsController statsController = Get.put(StatsController());

   MyApp(
      {super.key,
      required this.onBoardingCompleted,
      required this.isAuthenticated});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     statsController.fetchStatsData();
    return GetMaterialApp(
      title: 'Mentora',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SigninScreen(),
        // '/signup': (context) => const SignUpScreen(),
        // '/navigation': (context) => const NavigationMenu(),
      },
      home: onBoardingCompleted
          ? (isAuthenticated ? const NavigationMenu() : const SigninScreen())
          : const MyHomePage(title: 'Mentora Home Page'),
      // home: onBoardingCompleted
      //     ? const SignUpScreen()
      //     : const MyHomePage(title: 'Mentora Home Page'),
    );
    //  home: const NavigationMenu(),
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

  Future<void> completeOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onBoardingCompleted', true);

    // final bool isAuthenti
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    if (isAuthenticated) {
      Get.offAll(() => const NavigationMenu());
    } else {
      Get.offAll(() => const SignUpScreen());
    }
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const SignUpScreen()),
    // );
  }

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
                    if (currentPageIndex == 2) {
                      completeOnBoarding();
                    } else {
                      completeOnBoarding();
                      //  complete
                    }
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const SignUpScreen()));
                  },
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
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
