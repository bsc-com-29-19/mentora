class ApiEndpoints {
  static final String baseurl = "http://10.0.2.2:8400/mentora/api/v1";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
  static _JornalEndpoints journalEndpoints = _JornalEndpoints();
  static _ActivityEndpoints activityEndpoints = _ActivityEndpoints();
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
