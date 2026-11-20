class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      'username': username.trim(),
      'password': password,
    };
  }
}

class RegisterRequest {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String role;

  RegisterRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, String> toJson() {
    return {
      'full_name': fullName.trim(),
      'username': username.trim(),
      'email': email.trim(),
      'password': password,
      'role': role,
    };
  }
}

class AuthResponse {
  final String token;
  final String? role;
  final String? name;

  AuthResponse({
    required this.token,
    this.role,
    this.name,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return AuthResponse(
      token: json['token']?.toString() ?? '',
      role: user != null ? user['role']?.toString() : null,
      name: user != null ? user['name']?.toString() : null,
    );
  }
}