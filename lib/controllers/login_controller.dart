import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // URL API Laravel Anda
  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/login";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (usernameController.text.trim().isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Validasi', 
        'Email/Username dan Kata Sandi wajib diisi!',
        backgroundColor: Colors.amber.shade100, 
        colorText: Colors.amber.shade900,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
      );
      return;
    }

    isLoading.value = true;
    
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
        body: {
          'username': usernameController.text.trim(),
          'password': passwordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Simpan token otentikasi di lokal memori HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['data']['token']);

        // Masuk ke Dasbor Utama
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
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Bersihkan memori controller saat halaman dihancurkan
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}