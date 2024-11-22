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
    fetchJournal();
    _startResetTimer();
  }

  @override
  void onClose() {
    resetTimer?.cancel();
    super.onClose();
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token is missing. Please log in again.",
          backgroundColor: Colors.red.shade300, colorText: Colors.white);
      return null;
    }
    return token;
  }

  Future<void> fetchJournal() async {
    final token = await _loadToken();
    if (token == null) return;

    final SharedPreferences prefs = await _prefs;

    try {
      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.journalEndpoints.todayJournal);
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      logger.i("Fetching journal data from $url");
      logger.i("Token retrieved: $token");

      final response = await http.get(url, headers: headers);
      logger.i("Response: $response");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract data from the nested 'data' key
        final journalData = responseData['data'] ?? {};

        // Populate form fields with fetched data
        taskController.text = journalData['most_important_task'] ?? '';
        List<String> gratefulThings =
            List<String>.from(journalData['grateful_things'] ?? []);
        gratitudeController1.text =
            gratefulThings.isNotEmpty ? gratefulThings[0] : '';
        gratitudeController2.text =
            gratefulThings.length > 1 ? gratefulThings[1] : '';
        gratitudeController3.text =
            gratefulThings.length > 2 ? gratefulThings[2] : '';
        daySummaryController.text = journalData['day_summary'] ?? '';
        overallRating.value = journalData['overall_day_rating'] ?? 1;
        moodRating.value = journalData['overall_mood_rating'] ?? 1;
        taskCompleted.value =
            journalData['completed_most_important_task'] ?? false;

        // Save fetched data locally

        await prefs.setString('journal_data', jsonEncode(journalData));

        // logger.i("Fetched journal data: $journalData");
      } else {
        var errorDetail =
            jsonDecode(response.body)['detail'] ?? "Unknown error";
        logger.e("Failed to fetch journal data: $errorDetail");
        await prefs.remove('journal_data');

        // Get.snackbar("Error", "Failed to fetch journal data: $errorDetail",
        //     backgroundColor: Colors.red.shade300, colorText: Colors.white);
      }
    } catch (error) {
      logger.e("Error fetching journal data: $error");

      // Get.snackbar("Error", "An error occurred while fetching journal data.",
      //     backgroundColor: Colors.red.shade300, colorText: Colors.white);
    }
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

      // logger.i("Loaded saved journal data: $data");
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
    final token = await _loadToken();
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();

    try {
      // final SharedPreferences prefs = await _prefs;
      // var token = prefs.getString('token') ?? '';

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
      // logger.d("Submitting Journal: $encodedBody");

      http.Response response =
          await http.post(url, body: encodedBody, headers: headers);

      // logger.i("URL : $url");
      // logger.i("Response : ${response}");

      if (response.statusCode == 200) {
        statsController.fetchStatsData();
        if (response.body.isNotEmpty) {
          var responseData = jsonDecode(response.body);
          await prefs.setString('journal_data', jsonEncode(responseData));
          // logger.i("Response body : $responseData ");
        }

        Get.snackbar("Success", "Journal submitted successfully!",
            backgroundColor: Colors.green.shade300, colorText: Colors.white);
      } else if (response.statusCode == 409) {
        final errorDetail = jsonDecode(response.body)['detail'];
        final journalId = errorDetail['journal_id'];

        var updateUrl = Uri.parse(ApiEndpoints.baseurl +
            ApiEndpoints.journalEndpoints.updateJournal(
                journalId)); // Define the correct update endpoint
        http.Response updateResponse =
            await http.put(updateUrl, body: encodedBody, headers: headers);

        if (updateResponse.statusCode == 200) {
          // Journal updated successfully
          statsController.fetchStatsData();
          if (updateResponse.body.isNotEmpty) {
            var updatedData = jsonDecode(updateResponse.body);
            await prefs.setString('journal_data', jsonEncode(updatedData));
            logger.i("Updated journal data: $updatedData");
          }

          Get.snackbar("Success", "Journal updated successfully!",
              backgroundColor: Colors.green.shade300, colorText: Colors.white);
        } else {
          // Handle update failure
          var updateError =
              jsonDecode(updateResponse.body)['detail'] ?? "Unknown error";
          logger.e("Error updating journal: $updateError");
          Get.snackbar("Update Failed", updateError,
              backgroundColor: Colors.red.shade300, colorText: Colors.white);
        }
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
