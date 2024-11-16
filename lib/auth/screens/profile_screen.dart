// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String email = '';
  String fullName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Retrieve user data from SharedPreferences with default empty strings
      final storedUserName = prefs.getString('userName') ?? '';
      final storedEmail = prefs.getString('email') ?? '';
      final storedFullName = prefs.getString('fullName') ?? '';
      
      if (mounted) {
        // Check if essential data is missing
        if (storedUserName.isEmpty && storedEmail.isEmpty) {
          debugPrint('No user data found, redirecting to signin');
          await _handleLogout();
          return;
        }
        
        setState(() {
          userName = storedUserName;
          email = storedEmail;
          fullName = storedFullName;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Error loading user data. Please login again.');
        await _handleLogout();
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (mounted) {
        // Navigate to signin screen and remove all previous routes
        await Navigator.of(context).pushNamedAndRemoveUntil(
          '/signin',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (mounted) {
        _showErrorSnackBar('Error logging out. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          AccountIconButton(
            userName: userName,
            email: email,
            fullName: fullName,
            onLogout: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    fullName.isNotEmpty ? fullName : 'No name available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email.isNotEmpty ? email : 'No email available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}