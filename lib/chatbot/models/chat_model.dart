import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';

class ChatModel {
  final logger = Logger();

  // Send user message to the backend and get a response
  Future<String> sendMessage(
      String message, String sessionId, String? token) async {
    final url = Uri.parse(
        "${ApiEndpoints.baseurl}${ApiEndpoints.chatEndpoints.conversation}/$sessionId?user_message=$message");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? 'No response from server';
    } else {
      throw Exception('Failed to send message: ${response.reasonPhrase}');
    }
  }
}
