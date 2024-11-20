import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/stats/viewmodels/stats_view_model.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JournalController extends GetxController {
  final logger = Logger();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final StatsController statsController = Get.put(StatsController());

  // Controllers for form fields
  TextEditingController taskController = TextEditingController();
  TextEditingController gratitudeController1 = TextEditingController();
  TextEditingController gratitudeController2 = TextEditingController();
  TextEditingController gratitudeController3 = TextEditingController();
  TextEditingController daySummaryController = TextEditingController();

  // Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt overallRating = 1.obs;
  RxInt moodRating = 1.obs;
  RxBool taskCompleted = false.obs;

  Timer? resetTimer;

  @override
  void onInit() {
    super.onInit();
    _loadSavedJournalData();
    _startResetTimer();
  }

  @override
  void onClose() {
    resetTimer?.cancel();
    super.onClose();
  }

  void _loadSavedJournalData() async {
    final SharedPreferences prefs = await _prefs;
    String? savedJournalData = prefs.getString('journal_data');

    if (savedJournalData != null) {
      var data = jsonDecode(savedJournalData);

      // Populate form fields with saved data
      taskController.text = data['most_important_task'] ?? '';
      List<String> gratefulThings =
          List<String>.from(data['grateful_things'] ?? []);
      gratitudeController1.text =
          gratefulThings.isNotEmpty ? gratefulThings[0] : '';
      gratitudeController2.text =
          gratefulThings.length > 1 ? gratefulThings[1] : '';
      gratitudeController3.text =
          gratefulThings.length > 2 ? gratefulThings[2] : '';
      daySummaryController.text = data['day_summary'] ?? '';
      overallRating.value = data['overall_day_rating'] ?? 1;
      moodRating.value = data['overall_mood_rating'] ?? 1;
      taskCompleted.value = data['completed_most_important_task'] ?? false;

      logger.i("Loaded saved journal data: $data");
    }
  }

  void _startResetTimer() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    resetTimer = Timer(durationUntilMidnight, () {
      clearForm();
      _startResetTimer(); // Restart the timer for the next day
    });
  }

  void clearForm() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('journal_data');

    taskController.clear();
    gratitudeController1.clear();
    gratitudeController2.clear();
    gratitudeController3.clear();
    daySummaryController.clear();
    overallRating.value = 1;
    moodRating.value = 1;
    taskCompleted.value = false;
  }

  Future<void> submitJournal() async {
    try {
      final SharedPreferences prefs = await _prefs;
      var token = prefs.getString('token') ?? '';

      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.journalEndpoints.journal);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      Map body = {
        "most_important_task": taskController.text.trim(),
        "grateful_things": [
          gratitudeController1.text,
          gratitudeController2.text,
          gratitudeController3.text,
        ],
        "overall_day_rating": overallRating.value,
        "overall_mood_rating": moodRating.value,

        "completed_most_important_task": taskCompleted.value,
        "day_summary": daySummaryController.text.trim(),
        "mood_tags": ["string"]
        // "date": selectedDate.value.toIso8601String(),
      };

      var encodedBody = jsonEncode(body);
      logger.d("Submitting Journal: $encodedBody");

      http.Response response =
          await http.post(url, body: encodedBody, headers: headers);

      // logger.i("URL : $url");
      // logger.i("Response : ${response}");

      if (response.statusCode == 200) {
        statsController.fetchStatsData();
        if (response.body.isNotEmpty) {
          var responseData = jsonDecode(response.body);
          await prefs.setString('journal_data', jsonEncode(responseData));
          logger.i("Response body : $responseData ");
          // Handle the response data
        }

        Get.snackbar("Success", "Journal submitted successfully!",
            backgroundColor: Colors.green.shade300, colorText: Colors.white);
        // _clearForm();
      } else {
        var errorDetail =
            jsonDecode(response.body)['detail'] ?? "Unknown error";
        logger.e("Error submitting journal: $errorDetail");
        Get.snackbar("Submission Failed", errorDetail,
            backgroundColor: Colors.red.shade300, colorText: Colors.white);
      }
    } catch (error) {
      logger.e("Error submitting journal: $error");
      Get.snackbar("Error", "An error occurred while submitting your journal.",
          backgroundColor: Colors.red.shade300, colorText: Colors.white);
    }
  }
}
