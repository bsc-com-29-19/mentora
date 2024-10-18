import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mentora_frontend/chatbot/widgets/chat_bubble.dart';
import 'package:mentora_frontend/chatbot/widgets/chat_message.dart';

String _apiKey = "AIzaSyAeQYIn4le5MGM6z_OtXQEkrSaz3b8dUxE";

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollcontroller = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: "gemini-1.5-flash", apiKey: _apiKey);
    _chat = _model.startChat();

    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm a professional mental health therapist chatbot. I'm here to counsel, guide, and offer advice to support your mental well-being. How was your today?",
        isUser: false,
      ),
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCirc));
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text;

      setState(() {
        _messages.add(ChatMessage(text: text!, isUser: false));
        _scrollDown();
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "Error: $e", isUser: false));
      });
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mentora Therapist Bot"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: _scrollcontroller,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: _sendChatMessage,
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
                    onPressed: () => _sendChatMessage(_textController.text),
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
