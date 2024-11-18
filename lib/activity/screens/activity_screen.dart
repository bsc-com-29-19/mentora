import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
// import 'package:mentora_frontend/auth/widgets/custom_navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String username = '';
  String email = '';
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = prefs.getString('email') ?? 'email@example.com';
      fullName = prefs.getString('fullName') ?? 'Full Name';
    });
  }
  
  // Variables to store activity completion status
  bool runningCompleted = false;
  bool readingCompleted = false;
  bool walkOutsideCompleted = false;
  bool gymCompleted = false;
  bool socializeCompleted = false;
  bool meditateCompleted = false;

  // double completionPercentage = 0.0;
  int completedCount = 0;

  void _updateCompletionCount() {
    completedCount = [
      runningCompleted,
      readingCompleted,
      walkOutsideCompleted,
      gymCompleted,
      socializeCompleted,
      meditateCompleted
    ].where((completed) => completed).length;

    setState(() {
      // completionPercentage = (completedActivities / 6) * 100;
    });
  }

  // Function to build each activity with a completion checkbox
  Widget buildActivity(
      String title, bool completed, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              children: [
                // const Text(
                //   '0/1', // Shows the progress for each activity
                //   style: TextStyle(
                //       fontSize: 22.0,
                //       color: Colors.white,
                //       fontWeight: FontWeight.w500),
                // ),
                SizedBox(width: 10),
                Checkbox(
                  value: completed,
                  // onChanged: onChanged,
                  onChanged: (value) {
                    onChanged(value);
                    _updateCompletionCount(); // Update percentage on change
                  },
                  activeColor: Colors.white,
                  checkColor: Colors.green.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Variables to track the selected tab index
  // ignore: unused_field
  int _selectedIndex = 0;

  // Function to handle bottom navigation taps
  // ignore: unused_element
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      //  drawer: const CustomNavigationDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        title: const Text(
          'Activities',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold), // Making it bold
        ),
        
          actions: [
          AccountIconButton(
            username: username,
            email: email,
            fullName: fullName,
            onLogout: ProfileScreen.handleLogout,
          ),
        ],
      ),
     
     

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(26.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // This aligns the two texts to opposite sides
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  // '15 Sep, 2024',
                  "${DateTime.now().toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      // '0% Completed', // Adjust this based on completed activities
                      // '${completionPercentage.toStringAsFixed(0)}% Completed',
                      '$completedCount/6 Completed',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              children: [
                buildActivity('Running', runningCompleted, (value) {
                  setState(() {
                    runningCompleted = value!;
                  });
                }),
                buildActivity('Reading', readingCompleted, (value) {
                  setState(() {
                    readingCompleted = value!;
                  });
                }),
                buildActivity('Walk Outside', walkOutsideCompleted, (value) {
                  setState(() {
                    walkOutsideCompleted = value!;
                  });
                }),
                buildActivity('Go to the Gym', gymCompleted, (value) {
                  setState(() {
                    gymCompleted = value!;
                  });
                }),
                buildActivity('Socialize', socializeCompleted, (value) {
                  setState(() {
                    socializeCompleted = value!;
                  });
                }),
                buildActivity('Meditate for 2 hours', meditateCompleted,
                    (value) {
                  setState(() {
                    meditateCompleted = value!;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
