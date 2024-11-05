import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/widgets/logout_button.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  
  final String fullName = "";
  final String username = "";
  final String email = "";
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // floatingActionButton:
      //    LogoutButton(
      //   fullName: fullName,
      //   username: username,
      //   email: email,
      //   ),
        
      appBar: AppBar(
        title: const Text(
          "Stats",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),

          ),

          actions: [
           LogoutButton(
            fullName: '',  // Replace with dynamic user data
            username: '',  // Replace with dynamic user data
            email: '',  // Replace with dynamic user data
            onLogout: () {
        // Implement your logout functionality here
      },
    ),
  ],
      ),

      
    );
  }
}
