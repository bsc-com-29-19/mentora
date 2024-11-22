// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mentora_frontend/auth/screens/signin_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LogoutButton extends StatefulWidget {
//   final VoidCallback? onLogout;

//   const LogoutButton({
//     super.key,
//     this.onLogout,
//   });

//   @override
//   State<LogoutButton> createState() => _LogoutButtonState();
// }

// class _LogoutButtonState extends State<LogoutButton> {
//   String fullName = '';
//   String username = '';
//   String email = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       setState(() {
//         // Add debug print to check the stored value
//         print('Stored fullName: ${prefs.getString('fullName')}');

//         fullName = prefs.getString('fullName') ?? 'User';
//         username = prefs.getString('username') ?? 'User';
//         email = prefs.getString('email') ?? 'User';
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isAuthenticated', false);
//     Get.offAll(() => const SigninScreen());
//     // await prefs.clear();
//     // widget.onLogout?.call();
//   }

//   Future<void> _updateUserData(
//       String newFullName, String newUsername, String newEmail) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Debug print before saving
//       print('Saving fullName: $newFullName');

//       await prefs.setString('fullName', newFullName.trim());
//       await prefs.setString('username', newUsername.trim());
//       await prefs.setString('email', newEmail.trim());

//       // Verify the save was successful
//       final savedFullName = prefs.getString('fullName');
//       print('Verified saved fullName: $savedFullName');

//       await _loadUserData();
//     } catch (e) {
//       print('Error updating user data: $e');
//     }
//   }

//   void _showProfileDialog(BuildContext context) {
//     TextEditingController fullNameController =
//         TextEditingController(text: fullName);
//     TextEditingController usernameController =
//         TextEditingController(text: username);
//     TextEditingController emailController = TextEditingController(text: email);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: fullNameController,
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     labelText: 'Full Name',
//                     labelStyle: TextStyle(color: Colors.black),
//                     icon: Icon(Icons.person, color: Colors.green.shade300),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: usernameController,
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     labelStyle: TextStyle(color: Colors.black),
//                     icon: Icon(Icons.account_circle, color: Colors.green.shade300),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: emailController,
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(color: Colors.black),
//                     icon: Icon(Icons.email, color: Colors.green.shade300),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: TextStyle(color: Colors.green.shade300)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (fullNameController.text.trim().isNotEmpty) {
//                   await _updateUserData(
//                     fullNameController.text,
//                     usernameController.text,
//                     emailController.text,
//                   );
//                   // ignore: use_build_context_synchronously
//                   Navigator.pop(context);
//                 } else {
//                   // Show error if full name is empty
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Full name cannot be empty')),
//                   );
//                 }
//               },
//               child: Text('Save', style: TextStyle(color: Colors.green.shade300)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.menu, color: Colors.green.shade300),
//       onPressed: () => _showDrawer(context),
//       tooltip: 'Profile & Logout',
//     );
//   }

//   void _showDrawer(BuildContext context) {
//     Drawer drawer = Drawer(
//       backgroundColor: Colors.white,
//       child: ListView(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.green.shade300,
//             ),
//             accountName: Text(
//               fullName.isNotEmpty ? fullName : 'User',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             accountEmail: Text(
//               email,
//               style: TextStyle(color: Colors.white),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.account_circle, color: Colors.green.shade300),
//             title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
//             subtitle: Text(fullName,
//                 style:
//                     TextStyle(color: Colors.black)), // Added to show full name
//             onTap: () {
//               Navigator.pop(context);
//               _showProfileDialog(context);
//             },
//           ),
//           Divider(color: Colors.green.shade300),
//           ListTile(
//             leading: Icon(Icons.person_outline, color: Colors.green.shade300),
//             title: Text('Username', style: TextStyle(color: Colors.black)),
//             subtitle: Text(username, style: TextStyle(color: Colors.black)),
//           ),
//           ListTile(
//             leading: Icon(Icons.email_outlined, color: Colors.green.shade300),
//             title: Text('Email', style: TextStyle(color: Colors.black)),
//             subtitle: Text(email, style: TextStyle(color: Colors.black)),
//           ),
//           Divider(color: Colors.green.shade300),
//           ListTile(
//             leading: Icon(Icons.logout, color: Colors.green.shade300),
//             title: Text('Logout', style: TextStyle(color: Colors.black)),
//             onTap: () {
//               Navigator.of(context).pop();
//               _logout();
//             },
//           ),
//         ],
//       ),
//     );

//     Scaffold.of(context).openDrawer();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       builder: (BuildContext context) {
//         return drawer;
//       },
//     );
//   }
// }

