import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentora_frontend/auth/screens/profile_screen.dart';
import 'package:mentora_frontend/auth/widgets/account_icon_button.dart';
// import 'package:mentora_frontend/auth/widgets/custom_navigation_drawer.dart';

// import 'package:get/get.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:mentora_frontend/chatbot/models/chat_model.dart';
import 'package:mentora_frontend/chatbot/viewmodels/chatbot_viewmodel.dart';
import 'package:mentora_frontend/chatbot/widgets/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:mentora_frontend/chatbot/widgets/chat_message.dart';

// String _apiKey = "AIzaSyAeQYIn4le5MGM6z_OtXQEkrSaz3b8dUxE";

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  
  String username = '';
  String email = '';
  String fullName = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _loadUserData();
  // }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = prefs.getString('email') ?? 'email@example.com';
      fullName = prefs.getString('fullName') ?? 'Full Name';
    });
  }


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
     _loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     key: _scaffoldKey,
      //  drawer: const CustomNavigationDrawer(),

      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text(
          "Mentora Therapist",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        
        actions: [
          AccountIconButton(
            username: username,
            email: email,
            fullName: fullName,
            onLogout: ProfileScreen.handleLogout,
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
