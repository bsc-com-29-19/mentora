import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
import 'package:mentora_frontend/auth/widgets/button.dart';
import 'package:mentora_frontend/journal/viewmodel/journal_view_model.dart';
// import 'package:mentora_frontend/auth/widgets/custom_navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalScreen extends StatefulWidget {
  JournalScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final JournalController journalController = Get.find<JournalController>();

  DateTime selectedDate = DateTime.now();
  // int overallRating = 0;
  // int moodRating = 0;
  // bool taskCompleted = false;
  // TextEditingController taskController = TextEditingController();
  // TextEditingController gratitudeController1 = TextEditingController();
  // TextEditingController gratitudeController2 = TextEditingController();
  // TextEditingController gratitudeController3 = TextEditingController();
  // TextEditingController daySummaryController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: const CustomNavigationDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Journal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          AccountIconButton(
            username: username,
            email: email,
            fullName: fullName,
            onLogout: ProfileScreen.handleLogout,
          ),
        ],
      ),

      body: Container(
        color: Colors.green[50],
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Date selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Morning task
            TextField(
              controller: journalController.taskController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Write your most important task today',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gratitude fields
            const Text(
              'You are grateful for:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: journalController.gratitudeController1,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: '1.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: journalController.gratitudeController2,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: '2.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: journalController.gratitudeController3,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: '3.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Evening section
            const Text(
              'Evening',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Overall day rating
            const Text(
              'Overall Day Rating',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRadioWithLabel(
                    1,
                    'Awful',
                    journalController.overallRating.value,
                    (value) => setState(
                        () => journalController.overallRating.value = value!)),
                _buildRadioWithLabel(
                    2,
                    'Bad',
                    journalController.overallRating.value,
                    (value) => setState(
                        () => journalController.overallRating.value = value!)),
                _buildRadioWithLabel(
                    3,
                    'Ok',
                    journalController.overallRating.value,
                    (value) => setState(
                        () => journalController.overallRating.value = value!)),
                _buildRadioWithLabel(
                    4,
                    'Good',
                    journalController.overallRating.value,
                    (value) => setState(
                        () => journalController.overallRating.value = value!)),
                _buildRadioWithLabel(
                    5,
                    'Great',
                    journalController.overallRating.value,
                    (value) => setState(
                        () => journalController.overallRating.value = value!)),
              ],
            ),
            const SizedBox(height: 20),

            // Mood rating
            const Text(
              'Mood Rating',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRadioWithLabel(
                    1,
                    'Awful',
                    journalController.moodRating.value,
                    (value) => setState(
                        () => journalController.moodRating.value = value!)),
                _buildRadioWithLabel(
                    2,
                    'Bad',
                    journalController.moodRating.value,
                    (value) => setState(
                        () => journalController.moodRating.value = value!)),
                _buildRadioWithLabel(
                    3,
                    'Ok',
                    journalController.moodRating.value,
                    (value) => setState(
                        () => journalController.moodRating.value = value!)),
                _buildRadioWithLabel(
                    4,
                    'Good',
                    journalController.moodRating.value,
                    (value) => setState(
                        () => journalController.moodRating.value = value!)),
                _buildRadioWithLabel(
                    5,
                    'Great',
                    journalController.moodRating.value,
                    (value) => setState(
                        () => journalController.moodRating.value = value!)),
              ],
            ),
            const SizedBox(height: 20),

            // Task completed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Completed the most important task?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    )),
                Switch(
                  activeColor: Colors.green.shade300,
                  value: journalController.taskCompleted.value,
                  onChanged: (value) {
                    setState(() {
                      journalController.taskCompleted.value = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // How did you spend your day?
            TextField(
              controller: journalController.daySummaryController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: 'How did you spend your day?',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Submit button
            Button(
              text: 'Submit Journal',
              onPressed: journalController.submitJournal,
            ),
          ],
        ),
      ),
    );
  }

  // void _submitJournal() {
  //   // Gather the input data and perform submission logic
  //   String task = taskController.text;
  //   String gratitude1 = gratitudeController1.text;
  //   String gratitude2 = gratitudeController2.text;
  //   String gratitude3 = gratitudeController3.text;
  //   String daySummary = daySummaryController.text;

  //   // Print to console for now (replace with actual submission logic)
  //   print("Task: $task");
  //   print("Gratitude 1: $gratitude1");
  //   print("Gratitude 2: $gratitude2");
  //   print("Gratitude 3: $gratitude3");
  //   print("Overall Rating: $overallRating");
  //   print("Mood Rating: $moodRating");
  //   print("Task Completed: $taskCompleted");
  //   print("Day Summary: $daySummary");

  //   // Optionally clear the fields after submission
  //   taskController.clear();
  //   gratitudeController1.clear();
  //   gratitudeController2.clear();
  //   gratitudeController3.clear();
  //   daySummaryController.clear();
  //   setState(() {
  //     overallRating = 0;
  //     moodRating = 0;
  //     taskCompleted = false;
  //   });
  // }

  Widget _buildRadioWithLabel(
      int value, String label, int groupValue, ValueChanged<int?> onChanged) {
    return Column(
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          activeColor: Colors.green.shade300,
          onChanged: onChanged,
        ),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
