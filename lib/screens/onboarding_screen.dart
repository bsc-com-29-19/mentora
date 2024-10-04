import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('mentora')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/onboarding');
          },
          child: Text('Welcome click to continue'),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OnboardingPage(
      imagePath: 'images/image_1.png',
      title: ' Your journey to better life',
      description:
          'mentora analyzes your journal entries to generate personallized activities that improve your mental well-being.',
    ),
    OnboardingPage(
      imagePath: 'images/image_2.png',
      title: 'Therapist Bot at Your Side',
      description:
          'Get guided support with our AI therapist. Personalized advice tailored to your needs.',
    ),
     OnboardingPage(
      imagePath: 'images/image_3.png',
      title: 'Therapist Bot at Your Side',
      description:
          'Get guided support with our AI therapist. Personalized advice tailored to your needs.',
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _onSkip() {
    Navigator.pop(context); // Go back to the home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _pages[_currentIndex],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _onSkip, child: Text('Skip')),
                  Row(
                    children: List.generate(_pages.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? const Color.fromARGB(255, 76, 86, 175)
                              : const Color.fromARGB(255, 158, 158, 158),
                        ),
                      );
                    }),
                  ),
                  TextButton(onPressed: _onNext, child: Text('Next')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Encircled image
        ClipOval(
          child: Image.asset(
            imagePath,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
