import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/screens/signup_screen.dart';
import 'package:mentora_frontend/auth/viewmodels/signin_view_model.dart';

// Todo : redesign the page
class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  LoginController loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  final String _email = '';
 String _email = '';
  // ignore: unused_field
  String _password = '';

  // ignore: unused_field
  String _username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/mentora-logo.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Mentora',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: loginController.usernameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value!,
                    ),
                    // TextFormField(
                    //   controller: loginController.emailController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Email',
                    //     hintText: 'Enter your email address',
                    //     border: const OutlineInputBorder(),
                    //     focusedBorder: const OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.green),
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null ||
                    //         value.isEmpty ||
                    //         !value.contains('@')) {
                    //       return 'Please enter a valid email';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) => _email = value!,
                    // ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: loginController.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Please enter a password with at least 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Implement forgot password logic here
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          loginController.loginUser();
                          // ignore: avoid_print
                          // print('Sign In successful!');
                        }
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/sign-up');
                            // const SignUpScreen();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
