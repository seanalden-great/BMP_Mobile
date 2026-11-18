import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  var selectedRole = 'Staff'.obs; // Default (akan ditimpa di UI)
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/register";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    if (fullNameController.text.trim().isEmpty || 
        usernameController.text.trim().isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar('Validasi', 'Nama, Username, dan Kata Sandi wajib diisi!', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
      return;
    }

    isLoading.value = true;
    
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
        body: {
          'full_name': fullNameController.text.trim(),
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'role': selectedRole.value,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        // Pendaftaran sukses, lempar kembali ke halaman Login
        Get.back(); 
        Get.snackbar(
          'Pendaftaran Sukses', 
          'Akun berhasil dibuat. Silakan masuk menggunakan kredensial Anda.',
          backgroundColor: Colors.green.shade100, 
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 4),
        );
      } else {
        // Cek jika error validasi (misal username sudah ada)
        String errorMsg = data['message'] ?? 'Gagal mendaftar.';
        if (data['errors'] != null) {
          // Mengambil pesan error pertama dari validasi Laravel
          errorMsg = data['errors'].values.first[0].toString(); 
        }
        Get.snackbar('Registrasi Gagal', errorMsg, backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Gangguan Jaringan', 'Tidak dapat terhubung ke server ERP.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}