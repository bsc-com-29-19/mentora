import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  // Static method for handling logout
  static Future<void> handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Clear all user data
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('fullName');
      await prefs.remove('token');
      await prefs.setBool('isAuthenticated', false);

      await Get.offAllNamed('/signin'); // Redirect to the sign-in screen
    } catch (e) {
      debugPrint('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Error logging out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
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
      final storedUsername = prefs.getString('username') ?? '';
      final storedEmail = prefs.getString('email') ?? '';
      final storedFullName = prefs.getString('fullName') ?? '';
      final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

      if (mounted) {
        // Check both authentication status and data presence
        if (!isAuthenticated || (storedUsername.isEmpty && storedEmail.isEmpty)) {
          debugPrint('User not authenticated or no data found, redirecting to signin');
          await ProfileScreen.handleLogout();
          return;
        }

        setState(() {
          username = storedUsername;
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
        await ProfileScreen.handleLogout();
      }
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
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
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black, // AppBar text color
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          AccountIconButton(
            username: username,
            email: email,
            fullName: fullName,
            onLogout: ProfileScreen.handleLogout,
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
                  // Profile Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.green.shade300, // Avatar text color
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Full Name
                  Text(
                    fullName.isNotEmpty ? fullName : 'No name available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    email.isNotEmpty ? email : 'No email available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // Subtle text color
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
