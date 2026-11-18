import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var isSaving = false.obs;
  
  var userProfile = {}.obs;
  var loginLogs = [].obs;

  // Form Controllers
  final fullNameController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  
  var emailNotifications = true.obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile";
  final String apiUpdateUrl = "https://berlianmandiriperkasa.vercel.app/api/api/profile/update";

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Mengambil data pengguna dari server
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          userProfile.value = data['data']['user'];
          loginLogs.value = data['data']['login_logs'];
          _populateForm();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  // Mengisi form UI dengan data dari server
  void _populateForm() {
    fullNameController.text = userProfile['full_name'] ?? '';
    nameController.text = userProfile['name'] ?? '';
    phoneController.text = userProfile['phone'] ?? '';
    emailController.text = userProfile['email'] ?? '';
    usernameController.text = userProfile['username'] ?? '';
    emailNotifications.value = (userProfile['email_notifications'] == 1);
  }

  // Mengirim perubahan ke server
  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || usernameController.text.isEmpty) {
      Get.snackbar('Peringatan', 'Nama Panggilan dan Username wajib diisi!', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
      return;
    }

    if (passwordController.text.isNotEmpty && passwordController.text != passwordConfirmController.text) {
      Get.snackbar('Validasi Sandi', 'Konfirmasi kata sandi tidak cocok!', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    isSaving.value = true;
    try {
      final token = await _getToken();
      
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

      final response = await http.put(
        Uri.parse(apiUpdateUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        passwordController.clear();
        passwordConfirmController.clear();
        Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
        fetchProfile();
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan validasi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi internet', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSaving.value = false;
    }
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