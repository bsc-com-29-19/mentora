import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/viewmodels/signup_view_model.dart';
import 'package:mentora_frontend/auth/widgets/button.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SignupForm({super.key, required this.formKey});

  @override
  // ignore: library_private_types_in_public_api
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final RegistrationController registrationController = Get.put(RegistrationController());

  String fullName = '';
  String username = '';
  String email = '';
  String password = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name label and field
          const Text(
            'Full Name',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: registrationController.fullnameController,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (value.length < 2) {
                return 'Full name must be at least 2 characters long';
              }
              return null;
            },
            onSaved: (value) => fullName = value!,
          ),
          const SizedBox(height: 20),

          // Username label and field
          const Text(
            'Username',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: registrationController.usernameController,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Enter unique username',
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.contains(' ')) {
                return 'Username should not contain spaces';
              }
              return null;
            },
            onSaved: (value) => username = value!,
          ),
          const SizedBox(height: 20),

          // Email label and field
          const Text(
            'Email',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: registrationController.emailController,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => email = value!,
          ),
          const SizedBox(height: 20),

          // Password label and field
          const Text(
            'Password',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: registrationController.passwordController,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "Enter your secure password",
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green.shade300,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Please enter a password with at least 8 characters';
              }
              if (!RegExp(r'(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
                return 'Password must include at least one number and one uppercase letter';
              }
              return null;
            },
            onSaved: (value) => password = value!,
          ),
          const SizedBox(height: 20),

          Button(
           text: 'Sign Up',
           onPressed: () async {
           if (widget.formKey.currentState!.validate()) {
           widget.formKey.currentState!.save();
           await registrationController.registerUser();
           }
           },
           color: Colors.green.shade300, // Matches your color scheme
          ),

        ],
      ),
    );
  }
}
