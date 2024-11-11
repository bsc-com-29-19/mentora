import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/auth/screens/signin_screen.dart';
// import 'package:mentora_frontend/common/widgets/navigation_menu.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final logger = Logger();

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerUser() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.registerEmail);

      // print("Url : $url");
      Map body = {
        "full_name": fullnameController.text.trim(),
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim()
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

// Todo : When registration is successful, redirect to login page
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // var token = json['data']['token'];
        // var token = json['access_token'];

        logger.i("Response : $json");

        // print("access-token : $token");

        // final SharedPreferences? prefs = await _prefs;

        // await prefs?.setString('token', token);

        fullnameController.clear();
        usernameController.clear();
        emailController.clear();
        passwordController.clear();

        // Handle success Login
        Get.snackbar("Success", "You have successfully registered !",
            backgroundColor: Colors.green.shade300,
            colorText: Colors.white,
            icon: const Icon(Icons.check, color: Colors.white));

        // Get.offAll(() => const NavigationMenu());
        Get.off(() => const SigninScreen());
      } else {
        var errorDetail = jsonDecode(response.body)['detail'];

        logger.i("Response(Failed) : $errorDetail");

        Get.snackbar("Registration Failed", "$errorDetail",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error, color: Colors.white));

        // String errorMsg = errorDetail != null
        //     ? errorDetail[0]['msg']
        //     : "Unknown Error Occurred";
        // Get.snackbar("Error", errorMsg);
        // throw jsonDecode(response.body)['message'] ?? "unknown Error occurred";
      }
    } catch (e) {
      logger.e("Error : $e");
      Get.snackbar(
          "Error", "An Error Occurred: $e during Login. Please try again",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white));
    }
  }
}
