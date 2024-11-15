// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
// import 'package:mentora_frontend/utils/api_endpoints.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class JournalController extends GetxController {
//   // TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController emailorusernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController emailorusernameController = TextEditingController();

//   final logger = Logger();

//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   Future<void> loginUser() async {
//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var url = Uri.parse(
//           ApiEndpoints.baseurl + ApiEndpoints.journalEndpoints.journal);

//       // print("Url : $url");
//       logger.d("Url : $url");

//       Map body = {
//         // "email": emailController.text,
//         "usernameoremail": emailorusernameController.text.trim(),
//         "password": passwordController.text.trim()
//       };

//       // print("Body : $body");
//       logger.d("Body : $body");

//       http.Response response =
//           await http.post(url, body: jsonEncode(body), headers: headers);

//       logger.i("Response : $response");

//       logger.i("Response body : ${response.body}");

//       if (response.statusCode == 200) {
//         // access access_token & username from login response and keep them in local storage: shared_preferences
//         final json = jsonDecode(response.body);
//         logger.d("Response body : ${response.body}");
//         var token = json['access_token'];
//         var username = json['username'];
//         var email = json['email'];
//         var fullName = json['full_name'];

//         logger.d("Access Token : $token ");

//         final SharedPreferences prefs = await _prefs;

//         await prefs.setString('token', token);
//         await prefs.setString('username', username);
//         await prefs.setString('email', email);
//         await prefs.setString('fullName', fullName);
//         await prefs.setBool("isAuthenticated", true);

//         // emailController.clear();
//         emailorusernameController.clear();
//         passwordController.clear();

//         // Handle success Login
//         Get.snackbar("Success", "Your Login was Successful!",
//             backgroundColor: Colors.green.shade300,
//             colorText: Colors.white,
//             icon: const Icon(Icons.check, color: Colors.white));

//         Get.offAll(() => const NavigationMenu());
//       } else {
//         logger.d("Response body : ${response.body}");
//         logger.d("Response status code : ${response.statusCode}");
//         // print('Response status code: ${response.statusCode}');
//         // print('Response body: ${response.body}');

//         // throw jsonDecode(response.body)['message'] ?? "unknown Error occurred";
//         var errorDetail = jsonDecode(response.body)['detail'];

//         // String errorMsg = errorDetail != null
//         //     ? errorDetail[0]['msg']
//         //     : "Unknown Error Occurred";
//         // Get.snackbar("Error", errorMsg);

//         Get.snackbar("Login Failed", "$errorDetail",
//             colorText: Colors.white,
//             backgroundColor: Colors.red,
//             icon: const Icon(Icons.error, color: Colors.white));
//       }
//     } catch (e) {
//       logger.e("Error during Login", error: e.toString());
//       Get.snackbar("Error", "An Error Occurred: $e . Please try again");
//     }
//   }
// }

// File: journal_controller.dart

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

  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt overallRating = 0.obs;
  RxInt moodRating = 0.obs;
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

      Map<String, dynamic> body = {
        "most_important_task": taskController.text,
        "grateful_things": [
          gratitudeController1.text,
          gratitudeController2.text,
          gratitudeController3.text,
        ],
        "day_summary": daySummaryController.text,
        "overall_day_rating": overallRating.value,
        "overall_mood_rating": moodRating.value,
        "completed_most_important_task": taskCompleted.value,
        // "date": selectedDate.value.toIso8601String(),
      };

      logger.d("Submitting Journal: $body");

      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Journal submitted successfully!",
            backgroundColor: Colors.green.shade300, colorText: Colors.white);
        _clearForm();
      } else {
        var errorDetail =
            jsonDecode(response.body)['detail'] ?? "Unknown error";
        Get.snackbar("Submission Failed", errorDetail,
            backgroundColor: Colors.red.shade300, colorText: Colors.white);
      }
    } catch (error) {
      logger.e("Error submitting journal: $error");
      Get.snackbar("Error", "An error occurred while submitting your journal.",
          backgroundColor: Colors.red.shade300, colorText: Colors.white);
    }
  }

  void _clearForm() {
    taskController.clear();
    gratitudeController1.clear();
    gratitudeController2.clear();
    gratitudeController3.clear();
    daySummaryController.clear();
    overallRating.value = 0;
    moodRating.value = 0;
    taskCompleted.value = false;
    selectedDate.value = DateTime.now();
  }
}
