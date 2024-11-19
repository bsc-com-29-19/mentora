// signin_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/screens/signup_screen.dart';
import 'package:mentora_frontend/auth/viewmodels/signin_view_model.dart';
import 'package:mentora_frontend/auth/widgets/button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final LoginController loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;


  String username = '';
  String password = '';
  


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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email or Username',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: loginController.emailorusernameController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black, 
                      decoration: InputDecoration(
                        hintText: 'Enter your email or username',
                        hintStyle: const TextStyle(color: Colors.grey),
                        // labelText: 'Enter your email or username',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or username';
                        }
                        return null; 
                      },
                      onSaved: (value) => username = value!,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: loginController.passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black, 
                      decoration: InputDecoration(
                        
                        hintText: 'Enter your secure password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
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
                      onSaved: (value) => password = value!,
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
                    Button(
                      text: 'Sign In',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          loginController.loginUser();
                          
                        }
                      },
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.black),
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
