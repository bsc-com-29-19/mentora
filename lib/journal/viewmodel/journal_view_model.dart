import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JournalController extends GetxController {
  final logger = Logger();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

      logger.i("URL : $url");
      logger.i("Response : $response");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var responseData = jsonDecode(response.body
          );
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

  // void _clearForm() {
  //   taskController.clear();
  //   gratitudeController1.clear();
  //   gratitudeController2.clear();
  //   gratitudeController3.clear();
  //   daySummaryController.clear();
  //   overallRating.value = 0;
  //   moodRating.value = 0;
  //   taskCompleted.value = false;
  //   selectedDate.value = DateTime.now();
  // }
}
