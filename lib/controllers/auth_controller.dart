// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../routes/app_pages.dart';

// class AuthController extends GetxController {
//   // Base URL API
//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

//   // --- Form Controllers: LOGIN ---
//   final loginUsernameController = TextEditingController();
//   final loginPasswordController = TextEditingController();
//   var isLoginPasswordVisible = false.obs;
//   var isLoginLoading = false.obs;

//   // --- Form Controllers: REGISTER ---
//   final regFullNameController = TextEditingController();
//   final regUsernameController = TextEditingController();
//   final regEmailController = TextEditingController();
//   final regPasswordController = TextEditingController();
//   var selectedRole = 'Gudang'.obs;
//   var isRegPasswordVisible = false.obs;
//   var isRegLoading = false.obs;

//   void toggleLoginPasswordVisibility() {
//     isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
//   }

//   void toggleRegPasswordVisibility() {
//     isRegPasswordVisible.value = !isRegPasswordVisible.value;
//   }

//   // ==========================================
//   // PROSES LOGIN
//   // ==========================================
//   Future<void> login() async {
//     if (loginUsernameController.text.trim().isEmpty ||
//         loginPasswordController.text.isEmpty) {
//       Get.snackbar(
//         'Validasi',
//         'Email/Username dan Kata Sandi wajib diisi!',
//         backgroundColor: Colors.amber.shade100,
//         colorText: Colors.amber.shade900,
//         icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
//       );
//       return;
//     }

//     isLoginLoading.value = true;

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/login'),
//         headers: {'Accept': 'application/json'},
//         body: {
//           'username': loginUsernameController.text.trim(),
//           'password': loginPasswordController.text,
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', data['data']['token']);

//         Get.offAllNamed(Routes.MAIN_LAYOUT);
//       } else {
//         Get.snackbar(
//           'Akses Ditolak',
//           data['message'] ?? 'Kredensial tidak valid.',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           icon: const Icon(Icons.error_outline, color: Colors.red),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Gangguan Jaringan',
//         'Tidak dapat terhubung ke server ERP. Periksa koneksi internet Anda.',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//       );
//     } finally {
//       isLoginLoading.value = false;
//     }
//   }

//   // ==========================================
//   // PROSES REGISTRASI
//   // ==========================================
//   Future<void> register() async {
//     if (regFullNameController.text.trim().isEmpty ||
//         regUsernameController.text.trim().isEmpty ||
//         regPasswordController.text.isEmpty) {
//       Get.snackbar(
//         'Validasi',
//         'Nama, Username, dan Kata Sandi wajib diisi!',
//         backgroundColor: Colors.amber.shade100,
//         colorText: Colors.amber.shade900,
//       );
//       return;
//     }

//     isRegLoading.value = true;

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/register'),
//         headers: {'Accept': 'application/json'},
//         body: {
//           'full_name': regFullNameController.text.trim(),
//           'username': regUsernameController.text.trim(),
//           'email': regEmailController.text.trim(),
//           'password': regPasswordController.text,
//           'role': selectedRole.value,
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 201 && data['success'] == true) {
//         // Bersihkan form registrasi
//         regFullNameController.clear();
//         regUsernameController.clear();
//         regEmailController.clear();
//         regPasswordController.clear();
//         selectedRole.value = 'Gudang';

//         Get.back();
//         Get.snackbar(
//           'Pendaftaran Sukses',
//           'Akun berhasil dibuat. Silakan masuk menggunakan kredensial Anda.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           duration: const Duration(seconds: 4),
//         );
//       } else {
//         String errorMsg = data['message'] ?? 'Gagal mendaftar.';
//         if (data['errors'] != null) {
//           errorMsg = data['errors'].values.first[0].toString();
//         }
//         Get.snackbar(
//           'Registrasi Gagal',
//           errorMsg,
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Gangguan Jaringan',
//         'Tidak dapat terhubung ke server ERP.',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//       );
//     } finally {
//       isRegLoading.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     loginUsernameController.dispose();
//     loginPasswordController.dispose();
//     regFullNameController.dispose();
//     regUsernameController.dispose();
//     regEmailController.dispose();
//     regPasswordController.dispose();
//     super.onClose();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

  // --- Form Controllers: LOGIN ---
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();
  var isLoginPasswordVisible = false.obs;
  var isLoginLoading = false.obs;

  // --- Form Controllers: REGISTER ---
  final regFullNameController = TextEditingController();
  final regUsernameController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
  var selectedRole = 'Gudang'.obs;
  var isRegPasswordVisible = false.obs;
  var isRegLoading = false.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegPasswordVisibility() {
    isRegPasswordVisible.value = !isRegPasswordVisible.value;
  }

  // ==========================================
  // PROSES LOGIN
  // ==========================================
  Future<void> login() async {
    if (loginUsernameController.text.trim().isEmpty ||
        loginPasswordController.text.isEmpty) {
      Get.snackbar(
        'Validasi',
        'Email/Username dan Kata Sandi wajib diisi!',
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.amber.shade900,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
      );
      return;
    }

    isLoginLoading.value = true;

    try {
      final requestPayload = LoginRequest(
        username: loginUsernameController.text,
        password: loginPasswordController.text,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: requestPayload.toJson(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final authData = AuthResponse.fromJson(data['data'] ?? {});
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', authData.token);

        Get.offAllNamed(Routes.MAIN_LAYOUT);
      } else {
        Get.snackbar(
          'Akses Ditolak',
          data['message'] ?? 'Kredensial tidak valid.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gangguan Jaringan',
        'Tidak dapat terhubung ke server ERP. Periksa koneksi internet Anda.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  // ==========================================
  // PROSES REGISTRASI
  // ==========================================
  Future<void> register() async {
    if (regFullNameController.text.trim().isEmpty ||
        regUsernameController.text.trim().isEmpty ||
        regPasswordController.text.isEmpty) {
      Get.snackbar(
        'Validasi',
        'Nama, Username, dan Kata Sandi wajib diisi!',
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.amber.shade900,
      );
      return;
    }

    isRegLoading.value = true;

    try {
      final requestPayload = RegisterRequest(
        fullName: regFullNameController.text,
        username: regUsernameController.text,
        email: regEmailController.text,
        password: regPasswordController.text,
        role: selectedRole.value,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: requestPayload.toJson(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        regFullNameController.clear();
        regUsernameController.clear();
        regEmailController.clear();
        regPasswordController.clear();
        selectedRole.value = 'Gudang';

        Get.back();
        Get.snackbar(
          'Pendaftaran Sukses',
          'Akun berhasil dibuat. Silakan masuk menggunakan kredensial Anda.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 4),
        );
      } else {
        String errorMsg = data['message'] ?? 'Gagal mendaftar.';
        if (data['errors'] != null) {
          errorMsg = data['errors'].values.first[0].toString();
        }
        Get.snackbar(
          'Registrasi Gagal',
          errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gangguan Jaringan',
        'Tidak dapat terhubung ke server ERP.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isRegLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    regFullNameController.dispose();
    regUsernameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    super.onClose();
  }
}