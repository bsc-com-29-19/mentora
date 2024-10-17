import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ActivityPage(),
    );
  }
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // Variables to store activity completion status
  bool runningCompleted = false;
  bool readingCompleted = false;
  bool walkOutsideCompleted = false;
  bool gymCompleted = false;
  bool socializeCompleted = false;
  bool meditateCompleted = false;

  // Function to build each activity with a completion checkbox
  Widget buildActivity(
      String title, bool completed, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
            Row(
              children: [
                const Text(
                  '0/1', // Shows the progress for each activity
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 10),
                Checkbox(
                  value: completed,
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Variables to track the selected tab index
  int _selectedIndex = 0;

  // Function to handle bottom navigation taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activities',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold), // Making it bold
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '0% Completed', // Adjust this based on completed activities
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(29.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // This aligns the two texts to opposite sides
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '15 Sep, 2024',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 33.0),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the selected index
        onTap: _onItemTapped, // Handle bottom navigation tap
        selectedItemColor: Colors.teal,
        type: BottomNavigationBarType
            .fixed, // Ensure all icons and labels are shown
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'Therapy'),
        ],
      ),
    );
  }
}
