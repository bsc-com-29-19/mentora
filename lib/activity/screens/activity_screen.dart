import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/widgets/logout_button.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityScreen> {
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

  // void _handleLogout() {
  //   // Add navigation logic here
  //   Navigator.of(context).pushReplacementNamed('/login');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activities',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold), // Making it bold
        ),
        actions: [
          LogoutButton(
            onLogout: () {
              // Navigate to signin screen
              Navigator.pushReplacementNamed(context, '/signin');
            },
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
