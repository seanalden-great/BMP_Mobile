import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryController extends GetxController {
  // Observables untuk mendengarkan perubahan data di UI
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  
  var adjustments = [].obs;
  var products = [].obs;
  var warehouses = [].obs;

  // Sesuaikan dengan URL server backend Laravel Anda
  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    fetchMasterData();
  }

  // Helper untuk mengambil Token Sanctum dari penyimpanan lokal
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Mengambil Riwayat Mutasi / Penyesuaian
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          adjustments.value = data['data'];
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat riwayat inventori',
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Error Jaringan', 'Periksa koneksi internet Anda',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  // Mengambil Data Master (Produk & Gudang) untuk Pilihan Dropdown
  Future<void> fetchMasterData() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/master-data'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          products.value = data['data']['products'];
          warehouses.value = data['data']['warehouses'];
        }
      }
    } catch (e) {
      print("Gagal mengambil master data: $e");
    }
  }

  // Mengirim Data Penyesuaian Stok (Stock Opname) ke Backend
  Future<void> submitAdjustment({
    required String warehouseId,
    required String productSku,
    required String type,
    required String quantity,
    required String reason,
  }) async {
    isSubmitting.value = true;
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/adjust'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'date': DateTime.now().toIso8601String().split('T')[0],
          'warehouse_id': warehouseId,
          'product_sku': productSku,
          'type': type,
          'quantity': quantity,
          'reason': reason,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        Get.back(); // Tutup Form BottomSheet
        Get.snackbar(
          'Berhasil',
          'Stok berhasil disesuaikan & Jurnal telah dicatat.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        fetchHistory(); // Refresh riwayat
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal menyesuaikan stok',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi ke server',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSubmitting.value = false;
    }
  }
}