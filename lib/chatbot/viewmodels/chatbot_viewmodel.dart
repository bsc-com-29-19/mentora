// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mentora_frontend/chatbot/models/chat_model.dart';

import 'package:mentora_frontend/chatbot/widgets/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotController extends GetxController {
  final ChatModel _chatModel = ChatModel();
  // List<ChatMessage> _messages = [];
  var messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;

  final logger = Logger();

  // List<ChatMessage> get messages => _messages;
  // bool get isLoading => _isLoading;

  // Initialize the chatbot screen (retrieve username and start conversation)
  @override
  @override
  void onInit() {
    initializeChat();
    super.onInit();
  }

  Future<void> initializeChat() async {
    isLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final username = prefs.getString('username') ?? 'User';

      final initialMessage = "Hie, my name is : $username";

      messages.add(ChatMessage(text: initialMessage, isUser: true));
      // ..add(ChatMessage(
      //     text: username != null
      //         ? "Hello $username! I'm here to support your mental well-being. How was your day?"
      //         : "Hello!",
      //     isUser: false));

      final response = await _chatModel.sendMessage(
          initialMessage, 'your-session-id', token);

      messages.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: "Error: $e", isUser: false));
    }

    isLoading(false);
  }

  // Send user message and receive response from the backend
  Future<void> sendChatMessage(String message) async {
    if (message.trim().isEmpty) return;
    isLoading(true);

    try {
      // Add the user's message to the list
      messages.add(ChatMessage(text: message, isUser: true));

      // Retrieve the session ID and token (token from SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Send the message to the backend and get the response
      final response =
          await _chatModel.sendMessage(message, 'your-session-id', token);

      // Add the chatbot's response to the list
      messages.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: "Error: $e", isUser: false));
    }

    isLoading(false);
  }
}
