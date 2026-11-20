class UserProfile {
  final String fullName;
  final String name;
  final String phone;
  final String email;
  final String username;
  final String role;
  final bool emailNotifications;

  UserProfile({
    required this.fullName,
    required this.name,
    required this.phone,
    required this.email,
    required this.username,
    required this.role,
    required this.emailNotifications,
  });

  // Helper praktis untuk UI
  String get displayName =>
      fullName.isNotEmpty ? fullName : (name.isNotEmpty ? name : 'Pengguna');

  String get initial =>
      name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';

  bool get canManageRoles =>
      ['Admin', 'Direktur', 'Developer'].contains(role);

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final notif = json['email_notifications'];
    return UserProfile(
      fullName: json['full_name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Staff',
      emailNotifications: notif == 1 || notif == true || notif == '1',
    );
  }
}

class LoginLog {
  final String ipAddress;
  final String userAgent;
  final String createdAt;

  LoginLog({
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
  });

  bool get isMobile {
    final ua = userAgent.toLowerCase();
    return ua.contains('mobile') || ua.contains('android') || ua.contains('iphone');
  }

  factory LoginLog.fromJson(Map<String, dynamic> json) {
    return LoginLog(
      ipAddress: json['ip_address']?.toString() ?? 'Unknown IP',
      userAgent: json['user_agent']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}