// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileController extends GetxController {
//   var isLoading = true.obs;
//   var isSaving = false.obs;
  
//   var userProfile = {}.obs;
//   var loginLogs = [].obs;

//   // Form Controllers
//   final fullNameController = TextEditingController();
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final passwordConfirmController = TextEditingController();
  
//   var emailNotifications = true.obs;

//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile";
//   final String apiUpdateUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile/update";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Mengambil data pengguna dari server
//   Future<void> fetchProfile() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           userProfile.value = data['data']['user'];
//           loginLogs.value = data['data']['login_logs'];
//           _populateForm();
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal memuat profil.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Mengisi form UI dengan data dari server
//   void _populateForm() {
//     fullNameController.text = userProfile['full_name'] ?? '';
//     nameController.text = userProfile['name'] ?? '';
//     phoneController.text = userProfile['phone'] ?? '';
//     emailController.text = userProfile['email'] ?? '';
//     usernameController.text = userProfile['username'] ?? '';
//     emailNotifications.value = (userProfile['email_notifications'] == 1);
//   }

//   // Mengirim perubahan ke server
//   Future<void> updateProfile() async {
//     if (nameController.text.isEmpty || usernameController.text.isEmpty) {
//       Get.snackbar('Peringatan', 'Nama Panggilan dan Username wajib diisi!', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
//       return;
//     }

//     if (passwordController.text.isNotEmpty && passwordController.text != passwordConfirmController.text) {
//       Get.snackbar('Validasi Sandi', 'Konfirmasi kata sandi tidak cocok!', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       return;
//     }

//     isSaving.value = true;
//     try {
//       final token = await _getToken();
      
//       final Map<String, dynamic> bodyData = {
//         'full_name': fullNameController.text.trim(),
//         'name': nameController.text.trim(),
//         'username': usernameController.text.trim(),
//         'phone': phoneController.text.trim(),
//         'email': emailController.text.trim(),
//         'email_notifications': emailNotifications.value,
//       };

//       if (passwordController.text.isNotEmpty) {
//         bodyData['password'] = passwordController.text;
//       }

//       final response = await http.put(
//         Uri.parse(apiUpdateUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(bodyData),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success']) {
//         passwordController.clear();
//         passwordConfirmController.clear();
//         Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
//         fetchProfile();
//       } else {
//         Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan validasi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi internet', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSaving.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     fullNameController.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     passwordConfirmController.dispose();
//     super.onClose();
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/profile.dart';

// class ProfileController extends GetxController {
//   var isLoading = true.obs;
//   var isSaving = false.obs;

//   var userProfile = Rxn<UserProfile>();
//   var loginLogs = <LoginLog>[].obs;

//   // Form Controllers
//   final fullNameController = TextEditingController();
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final passwordConfirmController = TextEditingController();

//   var emailNotifications = true.obs;

//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile";
//   final String apiUpdateUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile/update";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Mengambil data pengguna dari server
//   Future<void> fetchProfile() async {
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
//           userProfile.value = UserProfile.fromJson(data['data']['user'] ?? {});
//           final List rawLogs = data['data']['login_logs'] ?? [];
//           loginLogs.value = rawLogs.map((e) => LoginLog.fromJson(e)).toList();
//           _populateForm();
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal memuat profil.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Mengisi form UI dengan data dari Model
//   void _populateForm() {
//     final user = userProfile.value;
//     if (user == null) return;

//     fullNameController.text = user.fullName;
//     nameController.text = user.name;
//     phoneController.text = user.phone;
//     emailController.text = user.email;
//     usernameController.text = user.username;
//     emailNotifications.value = user.emailNotifications;
//   }

//   // Mengirim perubahan ke server
//   Future<void> updateProfile() async {
//     if (nameController.text.isEmpty || usernameController.text.isEmpty) {
//       Get.snackbar('Peringatan', 'Nama Panggilan dan Username wajib diisi!',
//           backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
//       return;
//     }

//     if (passwordController.text.isNotEmpty &&
//         passwordController.text != passwordConfirmController.text) {
//       Get.snackbar('Validasi Sandi', 'Konfirmasi kata sandi tidak cocok!',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       return;
//     }

//     isSaving.value = true;
//     try {
//       final token = await _getToken();

//       final Map<String, dynamic> bodyData = {
//         'full_name': fullNameController.text.trim(),
//         'name': nameController.text.trim(),
//         'username': usernameController.text.trim(),
//         'phone': phoneController.text.trim(),
//         'email': emailController.text.trim(),
//         'email_notifications': emailNotifications.value,
//       };

//       if (passwordController.text.isNotEmpty) {
//         bodyData['password'] = passwordController.text;
//       }

//       final response = await http.put(
//         Uri.parse(apiUpdateUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(bodyData),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         passwordController.clear();
//         passwordConfirmController.clear();
//         Get.snackbar('Berhasil', data['message'] ?? 'Profil diperbarui.',
//             backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
//         fetchProfile();
//       } else {
//         Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan validasi',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi internet',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSaving.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     fullNameController.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     passwordConfirmController.dispose();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../services/local_database_service.dart';
import '../services/sync_service.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var isSaving = false.obs;

  var userProfile = Rxn<UserProfile>();
  var loginLogs = <LoginLog>[].obs;

  // Form Controllers
  final fullNameController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  var emailNotifications = true.obs;

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  final SyncService syncService = Get.find<SyncService>();
  final Duration requestTimeout = const Duration(seconds: 8);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();

    // Otomatis segarkan profil saat SyncService selesai mengirim data offline
    ever(syncService.lastSyncedAt, (_) {
      fetchProfile();
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ==========================================
  // READ: PROFIL (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      if (!syncService.isOnline.value) {
        await _loadProfileFromCache();
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse('$baseUrl/profile'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final payload = data['data'] ?? {};
          // Simpan ke SQLite Cache
          await LocalDatabaseService.instance
              .saveCache('user_profile', jsonEncode(payload));
          _applyProfileData(payload);
        }
      } else {
        await _loadProfileFromCache();
      }
    } catch (e) {
      // Koneksi putus / timeout -> baca dari SQLite
      await _loadProfileFromCache();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProfileFromCache() async {
    final cached = await LocalDatabaseService.instance.getCache('user_profile');
    if (cached != null) {
      _applyProfileData(jsonDecode(cached));
    }
  }

  void _applyProfileData(Map<String, dynamic> payload) {
    userProfile.value = UserProfile.fromJson(payload['user'] ?? {});
    final List rawLogs = payload['login_logs'] ?? [];
    loginLogs.value = rawLogs.map((e) => LoginLog.fromJson(e)).toList();
    _populateForm();
  }

  // Mengisi form UI dengan data dari Model
  void _populateForm() {
    final user = userProfile.value;
    if (user == null) return;

    fullNameController.text = user.fullName;
    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email;
    usernameController.text = user.username;
    emailNotifications.value = user.emailNotifications;
  }

  // ==========================================
  // UPDATE: PROFIL (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || usernameController.text.isEmpty) {
      Get.snackbar('Peringatan', 'Nama Panggilan dan Username wajib diisi!',
          backgroundColor: Colors.amber.shade100,
          colorText: Colors.amber.shade900);
      return;
    }

    if (passwordController.text.isNotEmpty &&
        passwordController.text != passwordConfirmController.text) {
      Get.snackbar('Validasi Sandi', 'Konfirmasi kata sandi tidak cocok!',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    isSaving.value = true;

    final Map<String, dynamic> bodyData = {
      'full_name': fullNameController.text.trim(),
      'name': nameController.text.trim(),
      'username': usernameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'email_notifications': emailNotifications.value,
    };

    if (passwordController.text.isNotEmpty) {
      bodyData['password'] = passwordController.text;
    }

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify(bodyData);
        return;
      }

      final token = await _getToken();
      final response = await http
          .put(
            Uri.parse('$baseUrl/profile/update'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(bodyData),
          )
          .timeout(requestTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        passwordController.clear();
        passwordConfirmController.clear();
        Get.snackbar('Berhasil', data['message'] ?? 'Profil diperbarui.',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900);
        fetchProfile();
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan validasi',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);
      }
    } catch (e) {
      // Koneksi putus / timeout saat menyimpan -> masuk antrean SQLite
      await _saveOfflineAndNotify(bodyData);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _saveOfflineAndNotify(Map<String, dynamic> bodyData) async {
    await LocalDatabaseService.instance.addToSyncQueue(
      method: 'PUT',
      endpoint: '/profile/update',
      payload: jsonEncode(bodyData),
      module: 'profile',
    );
    await syncService.refreshPendingCount();

    // Perbarui state lokal secara optimis agar UI langsung berubah
    final currentRole = userProfile.value?.role ?? 'Staff';
    userProfile.value = UserProfile(
      fullName: bodyData['full_name'] ?? '',
      name: bodyData['name'] ?? '',
      phone: bodyData['phone'] ?? '',
      email: bodyData['email'] ?? '',
      username: bodyData['username'] ?? '',
      role: currentRole,
      emailNotifications: bodyData['email_notifications'] == true,
    );

    passwordController.clear();
    passwordConfirmController.clear();

    Get.snackbar(
      'Tersimpan Offline',
      'Koneksi tidak stabil. Perubahan profil disimpan di HP & akan otomatis terkirim saat internet lancar.',
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      icon: const Icon(Icons.cloud_off, color: Colors.amber),
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}