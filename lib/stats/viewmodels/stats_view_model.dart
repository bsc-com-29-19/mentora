import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatsController extends GetxController {
  final logger = Logger();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var stats = {}.obs;

  var username = ''.obs;
  var email = ''.obs;
  var fullName = ''.obs;

  Future<void> fetchStatsData() async {
    isLoading(true);
    errorMessage('');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // logger.d("Token retrieved: $token");
    username.value = prefs.getString('username') ?? 'User';
    email.value = prefs.getString('email') ?? 'email@example.com';
    fullName.value = prefs.getString('fullName') ?? 'Full Name';

    try {
      if (token == null || token.isEmpty) {
        throw Exception("Token is missing. Please log in again.");
      }

      final url =
          Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.statsEndpoints.stats);

      // logger.d("Fetching stats data from $url");
      // logger.d("Token retrieved: $token");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        stats.value = jsonDecode(response.body);
        // logger.d("fetched stats: ${response.body}");
      } else {
        logger.d("Error fetching stats: ${response.body}");
        throw jsonDecode(response.body)['detail'] ?? 'Unknown error occurred.';
      }
    } catch (e) {
      // logger.e("Error during stats fetch", error: e.toString());
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  double calculateAverageRating() {
    if (stats.isEmpty || stats['all_days_trends'] == null) return 0.0;
    final trends = stats['all_days_trends'];
    final validRatings = trends
        .where((day) => day['average_day_rating'] > 0)
        .map((day) => day['average_day_rating']);
    return validRatings.isEmpty
        ? 0.0
        : validRatings.reduce((a, b) => a + b) / validRatings.length;
  }

  int getCompletionPercentage() {
    if (stats.isEmpty || stats['weekly_trends'] == null) return 0;
    return stats['weekly_trends']?['completion_percentage']?.toInt() ?? 0;
  }

  int calculateIncompleteActivities() {
    if (stats.isEmpty || stats['all_days_trends'] == null) return 0;
    final trends = stats['all_days_trends'];
    return trends.fold(
      0,
      (sum, day) => sum + (day['incomplete_activities'] ?? 0),
    );
  }

  List<dynamic> getAllDaysTrends() {
    // Safely return all_days_trends or an empty list if it's missing.
    return stats['all_days_trends'] ?? [];
  }
}
