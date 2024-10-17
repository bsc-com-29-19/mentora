class ApiEndpoints {
  static final String baseurl = "http://10.0.2.2:8400/mentora/api/v1";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = "/auth/register";
  final String loginEmail = "/auth/login";
}
