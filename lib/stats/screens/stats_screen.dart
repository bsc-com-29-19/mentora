import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mentora_frontend/auth/widgets/logout_button.dart';


class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  
  
//  void _handleLogout() {
//     // Add navigation logic here
//     Navigator.of(context).pushReplacementNamed('/login');
//   }

  @override
  Widget build(BuildContext context) {

 
    return Scaffold(  
      appBar: AppBar(
        title: const Text(
          "Stats",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),

          ),
       
      // actions: [
      //   LogoutButton(
      //   onLogout: _handleLogout,
      //     ),
      //   ],
          
      ),

      
    );
  }
}
