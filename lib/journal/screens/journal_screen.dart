import 'package:flutter/material.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
import 'package:mentora_frontend/auth/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();
  int overallRating = 0;
  int moodRating = 0;
  bool taskCompleted = false;
  TextEditingController taskController = TextEditingController();
  TextEditingController gratitudeController1 = TextEditingController();
  TextEditingController gratitudeController2 = TextEditingController();
  TextEditingController gratitudeController3 = TextEditingController();
  TextEditingController daySummaryController = TextEditingController();

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
              controller: taskController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Write your most important task today',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
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
              controller: gratitudeController1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: '1.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gratitudeController2,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: '2.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gratitudeController3,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: '3.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
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
                _buildRadioWithLabel(1, 'Awful', overallRating,
                    (value) => setState(() => overallRating = value!)),
                _buildRadioWithLabel(2, 'Bad', overallRating,
                    (value) => setState(() => overallRating = value!)),
                _buildRadioWithLabel(3, 'Ok', overallRating,
                    (value) => setState(() => overallRating = value!)),
                _buildRadioWithLabel(4, 'Good', overallRating,
                    (value) => setState(() => overallRating = value!)),
                _buildRadioWithLabel(5, 'Great', overallRating,
                    (value) => setState(() => overallRating = value!)),
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
                _buildRadioWithLabel(1, 'Awful', moodRating,
                    (value) => setState(() => moodRating = value!)),
                _buildRadioWithLabel(2, 'Bad', moodRating,
                    (value) => setState(() => moodRating = value!)),
                _buildRadioWithLabel(3, 'Ok', moodRating,
                    (value) => setState(() => moodRating = value!)),
                _buildRadioWithLabel(4, 'Good', moodRating,
                    (value) => setState(() => moodRating = value!)),
                _buildRadioWithLabel(5, 'Great', moodRating,
                    (value) => setState(() => moodRating = value!)),
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
                  value: taskCompleted,
                  onChanged: (value) {
                    setState(() {
                      taskCompleted = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // How did you spend your day?
            TextField(
              controller: daySummaryController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'How did you spend your day?',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Submit button
            Button(
              text: 'Submit Journal',
              onPressed: _submitJournal,
            ),
          ],
        ),
      ),
    );
  }

  void _submitJournal() {
    // Gather the input data here for processing or saving
    print("Journal Submitted");
  }

  Widget _buildRadioWithLabel(int value, String label, int groupValue,
      ValueChanged<int?> onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.green.shade300,
        ),
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
