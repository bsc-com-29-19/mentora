import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final logger = Logger();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> loginUser() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.loginEmail);

      // print("Url : $url");
      logger.d("Url : $url");

      Map body = {
        // "email": emailController.text,
        "username": usernameController.text,
        "password": passwordController.text
      };

      // print("Body : $body");
      logger.d("Body : $body");

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      // print("Response : $response");
      logger.i("Response : $response");

      // print("Response body : ${response.body}");
      logger.i("Response body : ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        var token = json['access_token'];

        // print("Access Token : $token ");
        logger.d("Access Token : $token ");

        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('token', token);

        // emailController.clear();
        usernameController.clear();
        passwordController.clear();

        // Handle success Login
        Get.snackbar("Login", "You are login in !");

        Get.offAll(() => const NavigationMenu());
      } else {
        logger.d("Response body : ${response.body}");
        logger.d("Response status code : ${response.statusCode}");
        // print('Response status code: ${response.statusCode}');
        // print('Response body: ${response.body}');

        // throw jsonDecode(response.body)['message'] ?? "unknown Error occurred";
        var errorDetail = jsonDecode(response.body)['detail'];

        String errorMsg = errorDetail != null
            ? errorDetail[0]['msg']
            : "Unknown Error Occurred";
        Get.snackbar("Error", errorMsg);
      }
    } catch (e) {
      logger.e("Error during Login", error: e.toString());
      Get.snackbar(
          "Error", "An Error Occurred: $e during Login. Please try again");
    }
  }
}