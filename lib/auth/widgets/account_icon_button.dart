// account_icon_button.dart
import 'package:flutter/material.dart';

class AccountIconButton extends StatelessWidget {
  final String username;
  final String email;
  final String fullName;
  final VoidCallback? onLogout;

  const AccountIconButton({
    super.key,
    required this.username,
    required this.email,
    required this.fullName,
    required this.onLogout,
  });

  


  void _handleLogoutConfirmation(BuildContext context) async {
    try {
      Navigator.pop(context); // Close the account menu
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );

      if (result == true) {
        await Future.delayed(const Duration(milliseconds: 200));
        onLogout!();
      }
    } catch (e) {
      debugPrint('Error during logout process: $e');
    }
  }

  void _showAccountMenu(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                right: 0,
              ),
              width: size.width * 0.85,
              height: size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            username.isNotEmpty ? username[0].toUpperCase() : 'U',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName.isNotEmpty ? fullName : 'No name available',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email.isNotEmpty ? email : 'No email available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    leading: const Icon(Icons.person_outline, size: 28),
                    title: const Text(
                      "Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      try {
                        Navigator.pop(context);
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Details"),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (username.isNotEmpty) ...[
                                      const Text(
                                        "Username:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(username),
                                      const SizedBox(height: 16),
                                    ],
                                    if (fullName.isNotEmpty) ...[
                                      const Text(
                                        "Full Name:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(fullName),
                                      const SizedBox(height: 16),
                                    ],
                                    if (email.isNotEmpty) ...[
                                      const Text(
                                        "Email:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(email),
                                    ],
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        debugPrint('Error showing profile details: $e');
                      }
                    },
                  ),
                  const Spacer(),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => _handleLogoutConfirmation(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person, color: Colors.black),
      onPressed: () => _showAccountMenu(context),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.logout),
//       onPressed: onLogout ?? () {
//         // Default action if onLogout is null
//         print("Logout function not provided");
//       },
//     );
//   }
// }