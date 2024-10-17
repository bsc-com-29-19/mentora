import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final logger = Logger();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerUser() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.registerEmail);

      print("Url : $url");
      Map body = {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // var token = json['data']['token'];
        var token = json['access_token'];

        logger.d("Response : $json");

        print("access-token : $token");

        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('token', token);

        usernameController.clear();
        emailController.clear();
        passwordController.clear();

// Handle success Login
        Get.snackbar("Register", "You have successfully registered !");

        // Get.offAll(() => const NavigationMenu());
        Get.off(NavigationMenu());
      } else {
        var errorDetail = jsonDecode(response.body)['detail'];

        String errorMsg = errorDetail != null
            ? errorDetail[0]['msg']
            : "Unknown Error Occurred";
        Get.snackbar("Error", errorMsg);
        // throw jsonDecode(response.body)['message'] ?? "unknown Error occurred";
      }
    } catch (e) {
      Get.snackbar(
          "Error", "An Error Occurred: $e during Login. Please try again");
    }
  }
}
