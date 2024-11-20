class ApiEndpoints {
  // static final String baseurl = "http://10.0.2.2:8400/mentora/api/v1";
  static final String baseurl =
      "https://mentora-6lpz.onrender.com/mentora/api/v1";
  static final _AuthEndPoints authEndpoints = _AuthEndPoints();
  static final _JornalEndpoints journalEndpoints = _JornalEndpoints();
  static final _ActivityEndpoints activityEndpoints = _ActivityEndpoints();
  static final _ChatEndpoints chatEndpoints = _ChatEndpoints();
  static final _StreamChatbotEndpoints streamChatbotEndpoints =
      _StreamChatbotEndpoints();

  static final _StatsEndpoints statsEndpoints = _StatsEndpoints();
}

class _AuthEndPoints {
  final String registerEmail = "/auth/register";
  final String loginEmail = "/auth/login";
}

class _JornalEndpoints {
  final String journal = "/journals/";
}

class _ActivityEndpoints {
  final String activities = "/activities/today";
  String updateActivity(String activityId) => "/activities/$activityId/status";
}

class _ChatEndpoints {
  final String conversation = "/chatbot/chat";
}

class _StreamChatbotEndpoints {
  final String streamChatbot = "/chatbot/ws/chat";
}

class _StatsEndpoints {
  final String stats = "/stats/";
}
