import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryController extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  
  var adjustments = [].obs;
  var products = [].obs;
  var warehouses = [].obs;

  // Hapus duplikat /api
  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    fetchMasterData();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/history'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) adjustments.value = data['data'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Periksa koneksi internet Anda', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMasterData() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/master-data'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          products.value = data['data']['products'];
          warehouses.value = data['data']['warehouses'];
        }
      }
    } catch (e) {
      debugPrint("Gagal mengambil master data: $e");
    }
  }

  Future<void> submitAdjustment({required String warehouseId, required String productSku, required String type, required String quantity, required String reason}) async {
    isSubmitting.value = true;
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/adjust'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
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
        Get.back(); 
        Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900, icon: const Icon(Icons.check_circle, color: Colors.green));
        fetchHistory(); 
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Gagal menyesuaikan stok', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900, icon: const Icon(Icons.error, color: Colors.red));
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSubmitting.value = false;
    }
  }

  // --- TAMBAHAN BARU: FUNGSI TRANSFER ---
  Future<void> submitTransfer({required String fromWarehouseId, required String toWarehouseId, required String productSku, required String quantity, required String notes}) async {
    isSubmitting.value = true;
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/transfer'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'date': DateTime.now().toIso8601String().split('T')[0],
          'from_warehouse_id': fromWarehouseId,
          'to_warehouse_id': toWarehouseId,
          'product_sku': productSku,
          'quantity': quantity,
          'notes': notes,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        Get.back(); 
        Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900, icon: const Icon(Icons.check_circle, color: Colors.green));
        fetchHistory(); 
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Gagal memproses mutasi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900, icon: const Icon(Icons.error, color: Colors.red));
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSubmitting.value = false;
    }
  }
}