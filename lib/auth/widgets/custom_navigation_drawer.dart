// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomNavigationDrawer extends StatefulWidget {
//   const CustomNavigationDrawer({super.key});

//   @override
//   State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
// }

// class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
//   String userName = '';
//   String email = '';
//   String fullName = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('userName') ?? 'User';
//       email = prefs.getString('email') ?? 'email@example.com';
//       fullName = prefs.getString('fullName') ?? 'Full Name';
//     });
//   }

//   Future<void> _handleLogout(BuildContext context) async {
//     final bool? confirm = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.green.shade300),
//               ),
//               onPressed: () => Navigator.of(context).pop(false),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade300,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Logout'),
//               onPressed: () => Navigator.of(context).pop(true),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm == true) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       if (context.mounted) {
//         Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.green.shade300,
//             ),
//             accountName: Text(
//               fullName,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             accountEmail: Text(
//               email,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 14,
//               ),
//             ),
//             currentAccountPicture: InkWell(
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                   style: TextStyle(
//                     fontSize: 32,
//                     color: Colors.green.shade300,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.logout,
//               color: Colors.black87,
//             ),
//             title: const Text(
//               'Logout',
//               style: TextStyle(fontSize: 16),
//             ),
//             onTap: () => _handleLogout(context),
//           ),
//         ],
//       ),
//     );
//   }
// }