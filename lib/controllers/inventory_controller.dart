// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class InventoryController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
  
//   var adjustments = [].obs;
//   var products = [].obs;
//   var warehouses = [].obs;

//   // Hapus duplikat /api
//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchHistory();
//     fetchMasterData();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchHistory() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/history'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) adjustments.value = data['data'];
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Periksa koneksi internet Anda', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchMasterData() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/master-data'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           products.value = data['data']['products'];
//           warehouses.value = data['data']['warehouses'];
//         }
//       }
//     } catch (e) {
//       debugPrint("Gagal mengambil master data: $e");
//     }
//   }

//   Future<void> submitAdjustment({required String warehouseId, required String productSku, required String type, required String quantity, required String reason}) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/adjust'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'warehouse_id': warehouseId,
//           'product_sku': productSku,
//           'type': type,
//           'quantity': quantity,
//           'reason': reason,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success']) {
//         Get.back(); 
//         Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900, icon: const Icon(Icons.check_circle, color: Colors.green));
//         fetchHistory(); 
//       } else {
//         Get.snackbar('Gagal', data['message'] ?? 'Gagal menyesuaikan stok', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900, icon: const Icon(Icons.error, color: Colors.red));
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   // --- TAMBAHAN BARU: FUNGSI TRANSFER ---
//   Future<void> submitTransfer({required String fromWarehouseId, required String toWarehouseId, required String productSku, required String quantity, required String notes}) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/transfer'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'from_warehouse_id': fromWarehouseId,
//           'to_warehouse_id': toWarehouseId,
//           'product_sku': productSku,
//           'quantity': quantity,
//           'notes': notes,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success']) {
//         Get.back(); 
//         Get.snackbar('Berhasil', data['message'], backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900, icon: const Icon(Icons.check_circle, color: Colors.green));
//         fetchHistory(); 
//       } else {
//         Get.snackbar('Gagal', data['message'] ?? 'Gagal memproses mutasi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900, icon: const Icon(Icons.error, color: Colors.red));
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/inventory.dart';

// class InventoryController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;

//   var adjustments = <StockAdjustment>[].obs;
//   var products = <InventoryProductOption>[].obs;
//   var warehouses = <Warehouse>[].obs;

//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchHistory();
//     fetchMasterData();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchHistory() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/history'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List rawList = data['data'] ?? [];
//           adjustments.value =
//               rawList.map((e) => StockAdjustment.fromJson(e)).toList();
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Periksa koneksi internet Anda',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchMasterData() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/master-data'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List rawProducts = data['data']['products'] ?? [];
//           final List rawWarehouses = data['data']['warehouses'] ?? [];

//           products.value =
//               rawProducts.map((e) => InventoryProductOption.fromJson(e)).toList();
//           warehouses.value =
//               rawWarehouses.map((e) => Warehouse.fromJson(e)).toList();
//         }
//       }
//     } catch (e) {
//       debugPrint("Gagal mengambil master data: $e");
//     }
//   }

//   Future<void> submitAdjustment({
//     required String warehouseId,
//     required String productSku,
//     required String type,
//     required String quantity,
//     required String reason,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/adjust'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'warehouse_id': warehouseId,
//           'product_sku': productSku,
//           'type': type,
//           'quantity': quantity,
//           'reason': reason,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.back();
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Penyesuaian stok berhasil.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchHistory();
//       } else {
//         Get.snackbar(
//           'Gagal',
//           data['message'] ?? 'Gagal menyesuaikan stok',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           icon: const Icon(Icons.error, color: Colors.red),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<void> submitTransfer({
//     required String fromWarehouseId,
//     required String toWarehouseId,
//     required String productSku,
//     required String quantity,
//     required String notes,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/transfer'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'from_warehouse_id': fromWarehouseId,
//           'to_warehouse_id': toWarehouseId,
//           'product_sku': productSku,
//           'quantity': quantity,
//           'notes': notes,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.back();
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Mutasi stok berhasil.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchHistory();
//       } else {
//         Get.snackbar(
//           'Gagal',
//           data['message'] ?? 'Gagal memproses mutasi',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           icon: const Icon(Icons.error, color: Colors.red),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/inventory.dart';

// class InventoryController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;

//   var adjustments = <StockAdjustment>[].obs;
//   var products = <InventoryProductOption>[].obs;
//   var warehouses = <Warehouse>[].obs;

//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchHistory();
//     fetchMasterData();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> fetchHistory() async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/history'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List rawList = data['data'] ?? [];
//           adjustments.value =
//               rawList.map((e) => StockAdjustment.fromJson(e)).toList();
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Periksa koneksi internet Anda',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchMasterData() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/inventory/master-data'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List rawProducts = data['data']['products'] ?? [];
//           final List rawWarehouses = data['data']['warehouses'] ?? [];

//           products.value =
//               rawProducts.map((e) => InventoryProductOption.fromJson(e)).toList();
//           warehouses.value =
//               rawWarehouses.map((e) => Warehouse.fromJson(e)).toList();
//         }
//       }
//     } catch (e) {
//       debugPrint("Gagal mengambil master data: $e");
//     }
//   }

//   Future<void> submitAdjustment({
//     required String warehouseId,
//     required String productSku,
//     required String type,
//     required String quantity,
//     required String reason,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/adjust'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'warehouse_id': warehouseId,
//           'product_sku': productSku,
//           'type': type,
//           'quantity': quantity,
//           'reason': reason,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.back();
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Penyesuaian stok berhasil.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchHistory();
//       } else {
//         Get.snackbar(
//           'Gagal',
//           data['message'] ?? 'Gagal menyesuaikan stok',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           icon: const Icon(Icons.error, color: Colors.red),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<void> submitTransfer({
//     required String fromWarehouseId,
//     required String toWarehouseId,
//     required String productSku,
//     required String quantity,
//     required String notes,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/inventory/transfer'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'from_warehouse_id': fromWarehouseId,
//           'to_warehouse_id': toWarehouseId,
//           'product_sku': productSku,
//           'quantity': quantity,
//           'notes': notes,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.back();
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Mutasi stok berhasil.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchHistory();
//       } else {
//         Get.snackbar(
//           'Gagal',
//           data['message'] ?? 'Gagal memproses mutasi',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           icon: const Icon(Icons.error, color: Colors.red),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventory.dart';
import '../services/local_database_service.dart';
import '../services/sync_service.dart';

class InventoryController extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  var adjustments = <StockAdjustment>[].obs;
  var products = <InventoryProductOption>[].obs;
  var warehouses = <Warehouse>[].obs;

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  final SyncService syncService = Get.find<SyncService>();
  final Duration requestTimeout = const Duration(seconds: 8);

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    fetchMasterData();

    // Otomatis refresh riwayat setiap kali SyncService selesai mengirim data offline
    ever(syncService.lastSyncedAt, (_) {
      fetchHistory();
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ==========================================
  // READ: RIWAYAT STOK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      if (!syncService.isOnline.value) {
        await _loadHistoryFromCache();
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse('$baseUrl/inventory/history'),
            headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List rawList = data['data'] ?? [];
          // Simpan ke SQLite Cache
          await LocalDatabaseService.instance
              .saveCache('inventory_history', jsonEncode(rawList));

          final serverItems =
              rawList.map((e) => StockAdjustment.fromJson(e)).toList();
          final pendingItems = await _getPendingLocalAdjustments();
          adjustments.value = [...pendingItems, ...serverItems];
        }
      } else {
        await _loadHistoryFromCache();
      }
    } catch (e) {
      // Koneksi putus atau timeout -> baca dari SQLite
      await _loadHistoryFromCache();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadHistoryFromCache() async {
    final cached = await LocalDatabaseService.instance.getCache('inventory_history');
    List<StockAdjustment> serverItems = [];
    if (cached != null) {
      final List rawList = jsonDecode(cached);
      serverItems = rawList.map((e) => StockAdjustment.fromJson(e)).toList();
    }
    final pendingItems = await _getPendingLocalAdjustments();
    adjustments.value = [...pendingItems, ...serverItems];
  }

  // Ubah antrean offline menjadi item UI sementara agar terlihat di daftar
  Future<List<StockAdjustment>> _getPendingLocalAdjustments() async {
    final queue = await LocalDatabaseService.instance.getPendingQueue();
    final List<StockAdjustment> pendingList = [];

    for (final item in queue) {
      if (item['module'] != 'inventory') continue;
      final body = jsonDecode(item['payload']);
      final sku = body['product_sku']?.toString() ?? '-';
      final prodMatch = products.firstWhereOrNull((p) => p.sku == sku);

      if (item['endpoint'] == '/inventory/adjust') {
        final whMatch = warehouses
            .firstWhereOrNull((w) => w.id.toString() == body['warehouse_id']?.toString());
        pendingList.add(StockAdjustment(
          date: body['date'] ?? '-',
          type: body['type'] ?? 'Penambahan',
          productSku: sku,
          productName: prodMatch?.name ?? sku,
          productUnit: '',
          warehouseName: whMatch?.name ?? 'Gudang #${body['warehouse_id']}',
          quantity: int.tryParse(body['quantity']?.toString() ?? '0') ?? 0,
          reason: body['reason'] ?? 'Penyesuaian Offline',
          isPendingSync: true,
        ));
      } else if (item['endpoint'] == '/inventory/transfer') {
        final fromWh = warehouses.firstWhereOrNull(
            (w) => w.id.toString() == body['from_warehouse_id']?.toString());
        final toWh = warehouses.firstWhereOrNull(
            (w) => w.id.toString() == body['to_warehouse_id']?.toString());
        pendingList.add(StockAdjustment(
          date: body['date'] ?? '-',
          type: 'Pengurangan',
          productSku: sku,
          productName: prodMatch?.name ?? sku,
          productUnit: '',
          warehouseName: '${fromWh?.name ?? 'Asal'} -> ${toWh?.name ?? 'Tujuan'}',
          quantity: int.tryParse(body['quantity']?.toString() ?? '0') ?? 0,
          reason: '[MUTASI OFFLINE] ${body['notes'] ?? ''}',
          isPendingSync: true,
        ));
      }
    }
    return pendingList.reversed.toList();
  }

  // ==========================================
  // READ: MASTER DATA (PRODUK & GUDANG)
  // ==========================================
  Future<void> fetchMasterData() async {
    try {
      if (!syncService.isOnline.value) {
        await _loadMasterDataFromCache();
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse('$baseUrl/inventory/master-data'),
            headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await LocalDatabaseService.instance
              .saveCache('inventory_master', jsonEncode(data['data']));
          _parseMasterData(data['data']);
        }
      } else {
        await _loadMasterDataFromCache();
      }
    } catch (e) {
      await _loadMasterDataFromCache();
    }
  }

  Future<void> _loadMasterDataFromCache() async {
    final cached = await LocalDatabaseService.instance.getCache('inventory_master');
    if (cached != null) {
      _parseMasterData(jsonDecode(cached));
    }
  }

  void _parseMasterData(Map<String, dynamic> payload) {
    final List rawProducts = payload['products'] ?? [];
    final List rawWarehouses = payload['warehouses'] ?? [];

    products.value =
        rawProducts.map((e) => InventoryProductOption.fromJson(e)).toList();
    warehouses.value =
        rawWarehouses.map((e) => Warehouse.fromJson(e)).toList();
  }

  // ==========================================
  // CREATE: STOCK OPNAME (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> submitAdjustment({
    required String warehouseId,
    required String productSku,
    required String type,
    required String quantity,
    required String reason,
  }) async {
    isSubmitting.value = true;
    final payload = {
      'date': DateTime.now().toIso8601String().split('T')[0],
      'warehouse_id': warehouseId,
      'product_sku': productSku,
      'type': type,
      'quantity': quantity,
      'reason': reason,
    };

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify('/inventory/adjust', payload);
        return;
      }

      final token = await _getToken();
      final response = await http
          .post(
            Uri.parse('$baseUrl/inventory/adjust'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(requestTimeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        Get.back();
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Penyesuaian stok berhasil.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        fetchHistory();
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
      // Timeout / internet putus saat mengirim -> masuk SQLite
      await _saveOfflineAndNotify('/inventory/adjust', payload);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==========================================
  // CREATE: MUTASI ANTAR GUDANG (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> submitTransfer({
    required String fromWarehouseId,
    required String toWarehouseId,
    required String productSku,
    required String quantity,
    required String notes,
  }) async {
    isSubmitting.value = true;
    final payload = {
      'date': DateTime.now().toIso8601String().split('T')[0],
      'from_warehouse_id': fromWarehouseId,
      'to_warehouse_id': toWarehouseId,
      'product_sku': productSku,
      'quantity': quantity,
      'notes': notes,
    };

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify('/inventory/transfer', payload);
        return;
      }

      final token = await _getToken();
      final response = await http
          .post(
            Uri.parse('$baseUrl/inventory/transfer'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(requestTimeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        Get.back();
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Mutasi stok berhasil.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        fetchHistory();
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal memproses mutasi',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } catch (e) {
      // Timeout / internet putus saat mengirim -> masuk SQLite
      await _saveOfflineAndNotify('/inventory/transfer', payload);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _saveOfflineAndNotify(
      String endpoint, Map<String, dynamic> payload) async {
    await LocalDatabaseService.instance.addToSyncQueue(
      method: 'POST',
      endpoint: endpoint,
      payload: jsonEncode(payload),
      module: 'inventory',
    );
    await syncService.refreshPendingCount();
    await _loadHistoryFromCache();

    Get.back();
    Get.snackbar(
      'Tersimpan Offline',
      'Koneksi tidak stabil. Data disimpan di HP & akan otomatis terkirim saat internet lancar.',
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      icon: const Icon(Icons.cloud_off, color: Colors.amber),
      duration: const Duration(seconds: 4),
    );
  }
}