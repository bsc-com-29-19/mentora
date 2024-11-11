import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/widgets/logout_button.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:get/get.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:mentora_frontend/chatbot/models/chat_model.dart';
import 'package:mentora_frontend/chatbot/viewmodels/chatbot_viewmodel.dart';
import 'package:mentora_frontend/chatbot/widgets/chat_bubble.dart';

// import 'package:mentora_frontend/chatbot/widgets/chat_message.dart';

// String _apiKey = "AIzaSyAeQYIn4le5MGM6z_OtXQEkrSaz3b8dUxE";

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotController _chatbotController = ChatbotController();
  final ScrollController _scrollcontroller = ScrollController();
  final TextEditingController _textController = TextEditingController();

  void _scrollDown() {
    Future.microtask(() =>
        _scrollcontroller.jumpTo(_scrollcontroller.position.maxScrollExtent));
  }

  @override
  void initState() {
    super.initState();
    // Call this whenever the messages list updates to scroll down
    _chatbotController.messages.listen((_) => _scrollDown());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Mentora Therapist",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      
         actions: [
         LogoutButton(
         onLogout: () {
          // Navigate to signin screen
          Navigator.pushReplacementNamed(context, '/signin');
        },
       ),
      ],
        

      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatbotController.messages.isEmpty) {
                // Show some placeholder if no messages
                return const Center(child: Text("No messages yet"));
              }

              return ListView.builder(
                // Use a fixed size to improve performance
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                controller: _scrollcontroller,
                itemCount: _chatbotController.messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                      message: _chatbotController.messages[index]);
                },
              );
            }),
          ),
          Obx(() => _chatbotController.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) =>
                        _chatbotController.sendChatMessage(value),
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Enter a Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _chatbotController.sendChatMessage(_textController.text);
                      _textController.clear();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
