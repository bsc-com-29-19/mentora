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
        title: Text("Journal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Date selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Morning task
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Write your most important task today',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Gratitude fields
            Text('You are grateful for:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController1,
              decoration: InputDecoration(
                hintText: '1.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController2,
              decoration: InputDecoration(
                hintText: '2.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: gratitudeController3,
              decoration: InputDecoration(
                hintText: '3.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Evening section
            Text(
              'Evening',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Overall day rating
            Text('Overall Day Rating', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                return _buildRadio(
                  index + 1,
                  overallRating,
                  (value) => setState(() => overallRating = value!),
                );
              }),
            ),
            SizedBox(height: 20),

            // Mood rating
            Text('Mood Rating', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                return _buildRadio(
                  index + 1,
                  moodRating,
                  (value) => setState(() => moodRating = value!),
                );
              }),
            ),
            SizedBox(height: 20),

            // Task completed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Complete the most important task?'),
                Switch(
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
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(int value, int groupValue, ValueChanged<int?> onChanged) {
    return Column(
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text('$value'),
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
