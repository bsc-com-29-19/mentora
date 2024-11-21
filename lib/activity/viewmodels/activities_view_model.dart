import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/stats/viewmodels/stats_view_model.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActivitiesController extends GetxController {
  final logger = Logger();
  final StatsController statsController = Get.put(StatsController());

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var activities = [].obs;

  var username = ''.obs;
  var email = ''.obs;
  var fullName = ''.obs;

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    username.value = prefs.getString('username') ?? 'User';
    email.value = prefs.getString('email') ?? 'email@example.com';
    fullName.value = prefs.getString('fullName') ?? 'Full Name';

    if (token == null || token.isEmpty) {
      errorMessage.value = "Token is missing. Please log in again.";
      return null;
    }

    return token;
  }

  Future<void> fetchActivities() async {
    isLoading(true);
    errorMessage('');

    final token = await loadToken();
    if (token == null) {
      isLoading(false);
      return; // Stop execution if token is missing
    }
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    // username.value = prefs.getString('username') ?? 'User';
    // email.value = prefs.getString('email') ?? 'email@example.com';
    // fullName.value = prefs.getString('fullName') ?? 'Full Name';

    try {
      // if (token == null || token.isEmpty) {
      //   throw Exception("Token is missing. Please log in again.");
      // }

      final url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.activityEndpoints.activities);

      // logger.d("Fetching activities from $url");
      // logger.d("Token retrieved:$token");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      logger.d("Response body: ${response.body}");

      if (response.statusCode == 200) {
        activities.value = jsonDecode(response.body);
        logger.i("Activities fetched: ${response.body}");
      } else {
        logger.d("Error fetching activities: ${response.body}");
        throw jsonDecode(response.body)['detail'] ?? 'Unknown error occurred.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateActivityStatus(String activityId, String newStatus) async {
    isLoading(true);
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');

    try {
      final token = await loadToken();
      if (token == null) {
        isLoading(false);
        return; // Stop execution if token is missing
      }

      final url = Uri.parse(ApiEndpoints.baseurl +
          ApiEndpoints.activityEndpoints.updateActivity(activityId));

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        await fetchActivities(); // Refresh activities
        statsController.fetchStatsData();
      } else {
        throw jsonDecode(response.body)['detail'] ?? 'Error updating activity.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
