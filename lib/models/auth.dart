// Matches proto/v1/auth.proto

class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() => {'login': login, 'password': password};
}

class RegisterRequest {
  final String login;
  final String password;

  const RegisterRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() => {'login': login, 'password': password};
}

class AuthResponse {
  final String token;

  const AuthResponse({required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(token: json['token'] as String);
  }
}
