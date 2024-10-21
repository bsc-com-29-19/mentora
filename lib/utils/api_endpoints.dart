class ApiEndpoints {
  // static final String baseurl = "http://10.0.2.2:8400/mentora/api/v1";
  static final String baseurl =
      "https://mentora-6lpz.onrender.com/mentora/api/v1";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
  static _JornalEndpoints journalEndpoints = _JornalEndpoints();
  static _ActivityEndpoints activityEndpoints = _ActivityEndpoints();
  static _ChatEndpoints chatEndpoints = _ChatEndpoints();
  static _StreamChatbotEndpoints streamChatbotEndpoints =
      _StreamChatbotEndpoints();
}

class _AuthEndPoints {
  final String registerEmail = "/auth/register";
  final String loginEmail = "/auth/login";
}

class _JornalEndpoints {
  final String journal = "/journals";
}

class _ActivityEndpoints {
  final String activities = "/activities";
}

class _ChatEndpoints {
  final String conversation = "/chatbot/chat";
}

class _StreamChatbotEndpoints {
  final String streamChatbot = "/chatbot/ws/chat";
}
