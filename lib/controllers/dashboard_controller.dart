import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var summary = {}.obs;
  var lowStocks = [].obs;
  var topProducts = [].obs;
  var topCustomers = [].obs;
  var recentActivities = [].obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/dashboard";

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          summary.value = data['data']['summary'];
          lowStocks.value = data['data']['low_stocks'];
          topProducts.value = data['data']['top_products'];
          topCustomers.value = data['data']['top_customers'];
          recentActivities.value = data['data']['recent_activities'];
        }
      } else {
        Get.snackbar('Sesi Berakhir', 'Silakan login kembali.', backgroundColor: Colors.amber);
      }
    } catch (e) {
      Get.snackbar('Koneksi Gagal', 'Gagal memuat data Dasbor Finansial.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }
}