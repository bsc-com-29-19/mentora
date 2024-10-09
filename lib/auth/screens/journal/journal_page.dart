import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  DateTime selectedDate = DateTime.now();
  int overallRating = 0;
  int moodRating = 0;
  bool taskCompleted = false;
  TextEditingController taskController = TextEditingController();
  TextEditingController gratitudeController1 = TextEditingController();
  TextEditingController gratitudeController2 = TextEditingController();
  TextEditingController gratitudeController3 = TextEditingController();
  TextEditingController daySummaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Journal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        color: Colors.green[50], // Light green background for the entire widget
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Date selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Morning task
            TextField(
              controller: taskController,
              decoration: InputDecoration(
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
            SizedBox(height: 20),

            // Gratitude fields
            Text('You are grateful for:',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController1,
              decoration: InputDecoration(
                hintText: '1.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController2,
              decoration: InputDecoration(
                hintText: '2.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController3,
              decoration: InputDecoration(
                hintText: '3.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Evening section
            Text(
              'Evening',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 20),

            // Overall day rating
            Text('Overall Day Rating',
                style: TextStyle(fontSize: 16, color: Colors.black)),
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
            SizedBox(height: 20),

            // Mood rating
            Text('Mood Rating',
                style: TextStyle(fontSize: 16, color: Colors.black)),
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
            SizedBox(height: 20),

            // Task completed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed the most important task?',
                    style: TextStyle(color: Colors.black)),
                Switch(
                  activeColor: Colors.green,
                  value: taskCompleted,
                  onChanged: (value) {
                    setState(() {
                      taskCompleted = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // How did you spend your day?
            TextField(
              controller: daySummaryController,
              decoration: InputDecoration(
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioWithLabel(
      int value, String label, int groupValue, ValueChanged<int?> onChanged) {
    return Column(
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        Text(label, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
