// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class RolePermissionController extends GetxController {
//   var isLoading = true.obs;
//   var isSaving = false.obs;

//   var currentRole = 'Staff'.obs;
//   var roles = <String>[].obs;
//   var menus = <String>[].obs;
//   var permissions = <String, dynamic>{}.obs;

//   // Sesuaikan jika base URL Anda memakai /api/api
//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/settings/roles";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPermissions();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchPermissions() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           currentRole.value = data['data']['current_role'] ?? 'Staff';
//           roles.value = List<String>.from(data['data']['roles'] ?? []);
//           menus.value = List<String>.from(data['data']['menus'] ?? []);
//           permissions.value = Map<String, dynamic>.from(data['data']['permissions'] ?? {});
//         }
//       }
//     } catch (e) {
//       debugPrint('Gagal memuat hak akses: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Cek apakah role tertentu boleh mengakses (Read) menu tertentu
//   bool hasReadAccess(String role, String menu) {
//     // Admin & Direktur default-nya selalu punya akses jika belum diatur
//     if (permissions.isEmpty && (role == 'Admin' || role == 'Direktur')) {
//       return true;
//     }
//     final rolePerms = permissions[role];
//     if (rolePerms is Map && rolePerms[menu] is List) {
//       return (rolePerms[menu] as List).contains('R');
//     }
//     return false;
//   }

//   // Helper cepat untuk user yang sedang login saat ini
//   bool canCurrentUserAccess(String menu) {
//     if (menu == 'Profil') return true; // Profil selalu terbuka agar user bisa logout
//     return hasReadAccess(currentRole.value, menu);
//   }

//   // Toggle checkbox akses menu (C, R, U, D sekaligus untuk mobile)
//   void toggleMenuAccess(String role, String menu, bool isChecked) {
//     final updated = Map<String, dynamic>.from(permissions);
//     final roleMap = Map<String, dynamic>.from(updated[role] ?? {});

//     if (isChecked) {
//       roleMap[menu] = ['C', 'R', 'U', 'D'];
//     } else {
//       roleMap[menu] = [];
//     }

//     updated[role] = roleMap;
//     permissions.value = updated;
//   }

//   // Simpan perubahan ke server Laravel
//   Future<void> savePermissions() async {
//     isSaving.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'permissions': permissions}),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Matriks hak akses berhasil disimpan!',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         await fetchPermissions();
//       } else {
//         Get.snackbar(
//           'Gagal',
//           data['message'] ?? 'Gagal menyimpan hak akses.',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSaving.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/role_permission.dart';

class RolePermissionController extends GetxController {
  var isLoading = true.obs;
  var isSaving = false.obs;

  var currentRole = 'Staff'.obs;
  var roles = <String>[].obs;
  var menus = <String>[].obs;
  var permissions = <String, Map<String, List<String>>>{}.obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/settings/roles";

  @override
  void onInit() {
    super.onInit();
    fetchPermissions();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchPermissions() async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final parsed = RolePermissionData.fromJson(data['data'] ?? {});
          currentRole.value = parsed.currentRole;
          roles.value = parsed.roles;
          menus.value = parsed.menus;
          permissions.value = parsed.permissions;
        }
      }
    } catch (e) {
      debugPrint('Gagal memuat hak akses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Cek apakah role tertentu boleh mengakses (Read) menu tertentu
  bool hasReadAccess(String role, String menu) {
    if (permissions.isEmpty && (role == 'Admin' || role == 'Direktur')) {
      return true;
    }
    final actions = permissions[role]?[menu];
    return actions != null && actions.contains('R');
  }

  // Helper cepat untuk user yang sedang login saat ini
  bool canCurrentUserAccess(String menu) {
    if (menu == 'Profil') return true;
    return hasReadAccess(currentRole.value, menu);
  }

  // Toggle checkbox akses menu (C, R, U, D sekaligus untuk mobile)
  void toggleMenuAccess(String role, String menu, bool isChecked) {
    final updated = Map<String, Map<String, List<String>>>.from(permissions);
    final roleMap = Map<String, List<String>>.from(updated[role] ?? {});

    roleMap[menu] = isChecked ? ['C', 'R', 'U', 'D'] : [];
    updated[role] = roleMap;
    permissions.value = updated;
  }

  // Simpan perubahan ke server Laravel
  Future<void> savePermissions() async {
    isSaving.value = true;
    try {
      final token = await _getToken();
      final payload = RolePermissionData(
        currentRole: currentRole.value,
        roles: roles,
        menus: menus,
        permissions: permissions,
      );

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload.toUpdatePayload()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Matriks hak akses berhasil disimpan!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        await fetchPermissions();
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal menyimpan hak akses.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi ke server.',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSaving.value = false;
    }
  }
}