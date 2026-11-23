class RolePermissionData {
  final String currentRole;
  final List<String> roles;
  final List<String> menus;
  final Map<String, Map<String, List<String>>> permissions;

  RolePermissionData({
    required this.currentRole,
    required this.roles,
    required this.menus,
    required this.permissions,
  });

  factory RolePermissionData.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, List<String>>> parsedPermissions = {};
    final rawPermissions = json['permissions'];

    if (rawPermissions is Map) {
      rawPermissions.forEach((roleKey, roleValue) {
        final Map<String, List<String>> menuMap = {};
        if (roleValue is Map) {
          roleValue.forEach((menuKey, actions) {
            if (actions is List) {
              menuMap[menuKey.toString()] =
                  actions.map((e) => e.toString()).toList();
            }
          });
        }
        parsedPermissions[roleKey.toString()] = menuMap;
      });
    }

    // return RolePermissionData(
    //   currentRole: json['current_role']?.toString() ?? 'Staff',
    //   roles: List<String>.from(json['roles'] ?? []),
    //   menus: List<String>.from(json['menus'] ?? []),
    //   permissions: parsedPermissions,
    // );

    return RolePermissionData(
      currentRole: json['current_role']?.toString() ?? 'Gudang',
      roles: List<String>.from(json['roles'] ?? []),
      menus: List<String>.from(json['menus'] ?? []),
      permissions: parsedPermissions,
    );
  }

  Map<String, dynamic> toUpdatePayload() {
    return {
      'permissions': permissions,
    };
  }
}