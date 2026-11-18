import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApprovalController extends GetxController {
  var isLoading = true.obs;
  var isProcessing = false.obs;
  var pendingDocuments = [].obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/approvals";

  @override
  void onInit() {
    super.onInit();
    fetchApprovals();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Mengambil daftar dokumen yang butuh persetujuan
  Future<void> fetchApprovals() async {
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
          pendingDocuments.value = data['data'];
        }
      }
    } catch (e) {
      Get.snackbar('Koneksi Gagal', 'Tidak dapat mengambil antrean persetujuan.',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  // Memproses Persetujuan / Penolakan Tunggal
  Future<void> processDocument(String url, bool isApprove) async {
    isProcessing.value = true;
    final actionText = isApprove ? 'menyetujui' : 'menolak';

    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Dokumen berhasil di$actionText.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        fetchApprovals(); // Segarkan daftar setelah berhasil
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan sistem.',
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi ke server.',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isProcessing.value = false;
    }
  }

  // Dialog Konfirmasi sebelum memproses
  void confirmAction(String url, bool isApprove) {
    final actionText = isApprove ? 'Setujui' : 'Tolak';
    final actionColor = isApprove ? Colors.green.shade700 : Colors.red.shade700;

    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Anda yakin ingin $actionText dokumen ini?",
      textCancel: "Batal",
      textConfirm: "Ya, $actionText",
      confirmTextColor: Colors.white,
      buttonColor: actionColor,
      onConfirm: () {
        Get.back(); // Tutup dialog
        processDocument(url, isApprove);
      },
    );
  }
}