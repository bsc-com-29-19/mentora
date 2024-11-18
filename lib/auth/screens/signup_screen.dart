import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/screens/signin_screen.dart';
import 'package:mentora_frontend/auth/widgets/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Consistent padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              // Header
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Mentora',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 24, // Header font size
                          fontWeight: FontWeight.bold, // Emphasized header
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Page Title
              const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Form
              SignupForm(formKey: _formKey),
              const SizedBox(height: 20),

              // Login Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey), // Subtle prompt color
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontWeight: FontWeight.bold, // Highlight the action
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
