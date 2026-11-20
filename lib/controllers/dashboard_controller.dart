// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardController extends GetxController {
//   var isLoading = true.obs;
//   var summary = {}.obs;
//   var lowStocks = [].obs;
//   var topProducts = [].obs;
//   var topCustomers = [].obs;
//   var recentActivities = [].obs;

//   // FUNGSI YANG DIPERBAIKI: Hapus /api ganda
//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/dashboard";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDashboardData();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchDashboardData() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           summary.value = data['data']['summary'];
//           lowStocks.value = data['data']['low_stocks'];
//           topProducts.value = data['data']['top_products'];
//           topCustomers.value = data['data']['top_customers'];
//           recentActivities.value = data['data']['recent_activities'];
//         }
//       } else {
//         Get.snackbar('Sesi Berakhir', 'Silakan login kembali.', backgroundColor: Colors.amber);
//       }
//     } catch (e) {
//       Get.snackbar('Koneksi Gagal', 'Gagal memuat data Dasbor Finansial.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/dashboard.dart';

// class DashboardController extends GetxController {
//   var isLoading = true.obs;
//   var summary = Rxn<DashboardSummary>();
//   var lowStocks = <LowStockItem>[].obs;
//   var topCustomers = <TopCustomerItem>[].obs;
//   var topProducts = [].obs;
//   var recentActivities = [].obs;

//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/dashboard";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDashboardData();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchDashboardData() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final payload = data['data'] ?? {};

//           summary.value = DashboardSummary.fromJson(payload['summary'] ?? {});

//           final List rawLowStocks = payload['low_stocks'] ?? [];
//           lowStocks.value =
//               rawLowStocks.map((e) => LowStockItem.fromJson(e)).toList();

//           final List rawTopCustomers = payload['top_customers'] ?? [];
//           topCustomers.value =
//               rawTopCustomers.map((e) => TopCustomerItem.fromJson(e)).toList();

//           topProducts.value = payload['top_products'] ?? [];
//           recentActivities.value = payload['recent_activities'] ?? [];
//         }
//       } else {
//         Get.snackbar('Sesi Berakhir', 'Silakan login kembali.',
//             backgroundColor: Colors.amber);
//       }
//     } catch (e) {
//       Get.snackbar('Koneksi Gagal', 'Gagal memuat data Dasbor Finansial.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard.dart';
import '../services/local_database_service.dart';
import '../services/sync_service.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var summary = Rxn<DashboardSummary>();
  var lowStocks = <LowStockItem>[].obs;
  var topCustomers = <TopCustomerItem>[].obs;
  var topProducts = [].obs;
  var recentActivities = [].obs;

  final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/dashboard";
  final SyncService syncService = Get.find<SyncService>();
  final Duration requestTimeout = const Duration(seconds: 8);

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();

    // Otomatis segarkan dasbor saat SyncService selesai mengirim data offline
    ever(syncService.lastSyncedAt, (_) {
      fetchDashboardData();
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ==========================================
  // READ: DASHBOARD (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      if (!syncService.isOnline.value) {
        await _loadDashboardFromCache();
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse(apiUrl),
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
              .saveCache('dashboard_data', jsonEncode(payload));
          _applyDashboardData(payload);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Sesi Berakhir', 'Silakan login kembali.',
            backgroundColor: Colors.amber);
      } else {
        await _loadDashboardFromCache();
      }
    } catch (e) {
      // Koneksi putus / timeout -> baca dari SQLite
      await _loadDashboardFromCache();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDashboardFromCache() async {
    final cached =
        await LocalDatabaseService.instance.getCache('dashboard_data');
    if (cached != null) {
      _applyDashboardData(jsonDecode(cached));
    }
  }

  void _applyDashboardData(Map<String, dynamic> payload) {
    summary.value = DashboardSummary.fromJson(payload['summary'] ?? {});

    final List rawLowStocks = payload['low_stocks'] ?? [];
    lowStocks.value =
        rawLowStocks.map((e) => LowStockItem.fromJson(e)).toList();

    final List rawTopCustomers = payload['top_customers'] ?? [];
    topCustomers.value =
        rawTopCustomers.map((e) => TopCustomerItem.fromJson(e)).toList();

    topProducts.value = payload['top_products'] ?? [];
    recentActivities.value = payload['recent_activities'] ?? [];
  }
}