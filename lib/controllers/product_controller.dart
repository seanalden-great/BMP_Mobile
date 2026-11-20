// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductController extends GetxController {
//   var isLoading = false.obs;
//   var isDetailLoading = false.obs;
//   var isSubmitting = false.obs;

//   var products = [].obs;
//   var categories = <String>[].obs;
//   var searchQuery = ''.obs;

//   // State untuk halaman Detail Kartu Stok
//   var productDetail = Rxn();

//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
//   Timer? _debounce;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Helper format Rupiah aman untuk String/int/double/null
//   String formatRupiah(dynamic value) {
//     final numVal = double.tryParse(value?.toString() ?? '0') ?? 0;
//     final intVal = numVal.round();
//     final str = intVal.abs().toString();
//     final buffer = StringBuffer();
//     for (int i = 0; i < str.length; i++) {
//       if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
//       buffer.write(str[i]);
//     }
//     return intVal < 0 ? '-Rp ${buffer.toString()}' : 'Rp ${buffer.toString()}';
//   }

//   void onSearchChanged(String query) {
//     searchQuery.value = query;
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 400), () {
//       fetchProducts(search: query);
//     });
//   }

//   Future<void> fetchProducts({String? search}) async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final q = search ?? searchQuery.value;
//       final uri = Uri.parse('$baseUrl/products').replace(
//         queryParameters: q.isNotEmpty ? {'search': q} : null,
//       );

//       final response = await http.get(
//         uri,
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           products.value = data['data']['products'] ?? [];
//           categories.value = List<String>.from(data['data']['categories'] ?? []);
//         }
//       } else {
//         Get.snackbar('Error', 'Gagal memuat daftar produk',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Gangguan Jaringan', 'Periksa koneksi internet Anda',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchProductDetail(int id) async {
//     isDetailLoading.value = true;
//     productDetail.value = null;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/products/$id'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           productDetail.value = data['data'];
//         }
//       } else {
//         Get.snackbar('Error', 'Gagal memuat detail kartu stok',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Gangguan Jaringan', 'Tidak dapat terhubung ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isDetailLoading.value = false;
//     }
//   }

//   Future<void> saveProduct({
//     int? id,
//     required String sku,
//     required String name,
//     required String category,
//     required String unit,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final isEdit = id != null;
//       final url = isEdit ? '$baseUrl/products/$id' : '$baseUrl/products';

//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       };
//       final body = jsonEncode({
//         'sku': sku.trim().toUpperCase(),
//         'name': name.trim(),
//         'category': category,
//         'unit': unit.trim().isEmpty ? 'Pcs' : unit.trim(),
//       });

//       final response = isEdit
//           ? await http.put(Uri.parse(url), headers: headers, body: body)
//           : await http.post(Uri.parse(url), headers: headers, body: body);

//       final data = jsonDecode(response.body);

//       if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
//         Get.back(); // Tutup BottomSheet
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Data produk disimpan.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchProducts();
//       } else {
//         String errorMsg = data['message'] ?? 'Gagal menyimpan produk.';
//         if (data['errors'] != null) {
//           errorMsg = data['errors'].values.first[0].toString();
//         }
//         Get.snackbar('Gagal', errorMsg,
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<void> deleteProduct(int id) async {
//     try {
//       final token = await _getToken();
//       final response = await http.delete(
//         Uri.parse('$baseUrl/products/$id'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.snackbar(
//           'Terhapus',
//           data['message'] ?? 'Produk berhasil dihapus.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//         );
//         fetchProducts();
//       } else {
//         Get.snackbar(
//           'Gagal Menghapus',
//           data['message'] ?? 'Produk tidak dapat dihapus.',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     }
//   }

//   @override
//   void onClose() {
//     _debounce?.cancel();
//     super.onClose();
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/product.dart';

// class ProductController extends GetxController {
//   var isLoading = false.obs;
//   var isDetailLoading = false.obs;
//   var isSubmitting = false.obs;

//   var products = <Product>[].obs;
//   var categories = <String>[].obs;
//   var searchQuery = ''.obs;

//   var productDetail = Rxn<ProductDetail>();

//   final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
//   Timer? _debounce;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   String formatRupiah(double value) {
//     final intVal = value.round();
//     final str = intVal.abs().toString();
//     final buffer = StringBuffer();
//     for (int i = 0; i < str.length; i++) {
//       if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
//       buffer.write(str[i]);
//     }
//     return intVal < 0 ? '-Rp ${buffer.toString()}' : 'Rp ${buffer.toString()}';
//   }

//   void onSearchChanged(String query) {
//     searchQuery.value = query;
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 400), () {
//       fetchProducts(search: query);
//     });
//   }

//   Future<void> fetchProducts({String? search}) async {
//     isLoading.value = true;
//     try {
//       final token = await _getToken();
//       final q = search ?? searchQuery.value;
//       final uri = Uri.parse('$baseUrl/products').replace(
//         queryParameters: q.isNotEmpty ? {'search': q} : null,
//       );

//       final response = await http.get(
//         uri,
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List rawProducts = data['data']['products'] ?? [];
//           products.value = rawProducts.map((e) => Product.fromJson(e)).toList();
//           categories.value = List<String>.from(data['data']['categories'] ?? []);
//         }
//       } else {
//         Get.snackbar('Error', 'Gagal memuat daftar produk',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Gangguan Jaringan', 'Periksa koneksi internet Anda',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchProductDetail(int id) async {
//     isDetailLoading.value = true;
//     productDetail.value = null;
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/products/$id'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           productDetail.value = ProductDetail.fromJson(data['data']);
//         }
//       } else {
//         Get.snackbar('Error', 'Gagal memuat detail kartu stok',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Gangguan Jaringan', 'Tidak dapat terhubung ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isDetailLoading.value = false;
//     }
//   }

//   Future<void> saveProduct({
//     int? id,
//     required String sku,
//     required String name,
//     required String category,
//     required String unit,
//   }) async {
//     isSubmitting.value = true;
//     try {
//       final token = await _getToken();
//       final isEdit = id != null;
//       final url = isEdit ? '$baseUrl/products/$id' : '$baseUrl/products';

//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       };
//       final body = jsonEncode({
//         'sku': sku.trim().toUpperCase(),
//         'name': name.trim(),
//         'category': category,
//         'unit': unit.trim().isEmpty ? 'Pcs' : unit.trim(),
//       });

//       final response = isEdit
//           ? await http.put(Uri.parse(url), headers: headers, body: body)
//           : await http.post(Uri.parse(url), headers: headers, body: body);

//       final data = jsonDecode(response.body);

//       if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
//         Get.back();
//         Get.snackbar(
//           'Berhasil',
//           data['message'] ?? 'Data produk disimpan.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           icon: const Icon(Icons.check_circle, color: Colors.green),
//         );
//         fetchProducts();
//       } else {
//         String errorMsg = data['message'] ?? 'Gagal menyimpan produk.';
//         if (data['errors'] != null) {
//           errorMsg = data['errors'].values.first[0].toString();
//         }
//         Get.snackbar('Gagal', errorMsg,
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<void> deleteProduct(int id) async {
//     try {
//       final token = await _getToken();
//       final response = await http.delete(
//         Uri.parse('$baseUrl/products/$id'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.snackbar(
//           'Terhapus',
//           data['message'] ?? 'Produk berhasil dihapus.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//         );
//         fetchProducts();
//       } else {
//         Get.snackbar(
//           'Gagal Menghapus',
//           data['message'] ?? 'Produk tidak dapat dihapus.',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     }
//   }

//   @override
//   void onClose() {
//     _debounce?.cancel();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/local_database_service.dart';
import '../services/sync_service.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isDetailLoading = false.obs;
  var isSubmitting = false.obs;

  var products = <Product>[].obs;
  var categories = <String>[].obs;
  var searchQuery = ''.obs;

  var productDetail = Rxn<ProductDetail>();

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  final SyncService syncService = Get.find<SyncService>();
  final Duration requestTimeout = const Duration(seconds: 8);
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // Otomatis refresh daftar produk saat SyncService selesai mengirim antrean offline
    ever(syncService.lastSyncedAt, (_) {
      fetchProducts();
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  String formatRupiah(double value) {
    final intVal = value.round();
    final str = intVal.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return intVal < 0 ? '-Rp ${buffer.toString()}' : 'Rp ${buffer.toString()}';
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchProducts(search: query);
    });
  }

  // ==========================================
  // READ: DAFTAR PRODUK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchProducts({String? search}) async {
    isLoading.value = true;
    final q = (search ?? searchQuery.value).trim();

    try {
      if (!syncService.isOnline.value) {
        await _loadProductsFromCache(search: q);
        return;
      }

      final token = await _getToken();
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: q.isNotEmpty ? {'search': q} : null,
      );

      final response = await http
          .get(
            uri,
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
          // Simpan cache penuh hanya ketika tidak sedang memfilter pencarian
          if (q.isEmpty) {
            await LocalDatabaseService.instance
                .saveCache('products_list', jsonEncode(payload));
          }

          final List rawProducts = payload['products'] ?? [];
          final serverList =
              rawProducts.map((e) => Product.fromJson(e)).toList();
          categories.value = List<String>.from(payload['categories'] ?? []);
          products.value = await _mergePendingProducts(serverList, search: q);
        }
      } else {
        await _loadProductsFromCache(search: q);
      }
    } catch (e) {
      // Koneksi putus / timeout -> baca dari SQLite
      await _loadProductsFromCache(search: q);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProductsFromCache({String search = ''}) async {
    final cached =
        await LocalDatabaseService.instance.getCache('products_list');
    List<Product> serverList = [];

    if (cached != null) {
      final payload = jsonDecode(cached);
      final List rawProducts = payload['products'] ?? [];
      serverList = rawProducts.map((e) => Product.fromJson(e)).toList();
      categories.value = List<String>.from(payload['categories'] ?? []);
    }

    products.value = await _mergePendingProducts(serverList, search: search);
  }

  // Gabungkan antrean offline (POST, PUT, DELETE) ke daftar produk lokal
  Future<List<Product>> _mergePendingProducts(List<Product> baseList,
      {String search = ''}) async {
    final queue = await LocalDatabaseService.instance.getPendingQueue();
    final List<Product> merged = List<Product>.from(baseList);

    for (final item in queue) {
      if (item['module'] != 'product') continue;

      final String method = item['method'] ?? '';
      final String endpoint = item['endpoint'] ?? '';
      final Map<String, dynamic> body =
          item['payload'] != null && item['payload'].toString().isNotEmpty
              ? jsonDecode(item['payload'])
              : {};

      if (method == 'POST' && endpoint == '/products') {
        merged.insert(
          0,
          Product(
            id: -(item['id'] as int), // ID negatif menandakan produk baru offline
            sku: body['sku']?.toString() ?? '-',
            name: body['name']?.toString() ?? '-',
            category: body['category']?.toString() ?? '-',
            unit: body['unit']?.toString() ?? 'Pcs',
            buyPrice: 0,
            sellPrice: 0,
            hpp: 0,
            totalStock: 0,
            isPendingSync: true,
          ),
        );
      } else if (method == 'PUT' && endpoint.startsWith('/products/')) {
        final targetId = int.tryParse(endpoint.split('/').last);
        if (targetId != null) {
          final idx = merged.indexWhere((p) => p.id == targetId);
          if (idx != -1) {
            final old = merged[idx];
            merged[idx] = Product(
              id: old.id,
              sku: body['sku']?.toString() ?? old.sku,
              name: body['name']?.toString() ?? old.name,
              category: body['category']?.toString() ?? old.category,
              unit: body['unit']?.toString() ?? old.unit,
              buyPrice: old.buyPrice,
              sellPrice: old.sellPrice,
              hpp: old.hpp,
              totalStock: old.totalStock,
              isPendingSync: true,
            );
          }
        }
      } else if (method == 'DELETE' && endpoint.startsWith('/products/')) {
        final targetId = int.tryParse(endpoint.split('/').last);
        if (targetId != null) {
          merged.removeWhere((p) => p.id == targetId);
        }
      }
    }

    if (search.isNotEmpty) {
      final keyword = search.toLowerCase();
      return merged
          .where((p) =>
              p.name.toLowerCase().contains(keyword) ||
              p.sku.toLowerCase().contains(keyword) ||
              p.category.toLowerCase().contains(keyword))
          .toList();
    }

    return merged;
  }

  // ==========================================
  // READ: DETAIL KARTU STOK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchProductDetail(int id) async {
    isDetailLoading.value = true;
    productDetail.value = null;

    try {
      if (!syncService.isOnline.value) {
        await _loadProductDetailFromCache(id);
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse('$baseUrl/products/$id'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await LocalDatabaseService.instance
              .saveCache('product_detail_$id', jsonEncode(data['data']));
          productDetail.value = ProductDetail.fromJson(data['data']);
        }
      } else {
        await _loadProductDetailFromCache(id);
      }
    } catch (e) {
      await _loadProductDetailFromCache(id);
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> _loadProductDetailFromCache(int id) async {
    final cached =
        await LocalDatabaseService.instance.getCache('product_detail_$id');
    if (cached != null) {
      productDetail.value = ProductDetail.fromJson(jsonDecode(cached));
    }
  }

  // ==========================================
  // CREATE & UPDATE PRODUK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> saveProduct({
    int? id,
    required String sku,
    required String name,
    required String category,
    required String unit,
  }) async {
    isSubmitting.value = true;
    final isEdit = id != null;
    final endpoint = isEdit ? '/products/$id' : '/products';
    final method = isEdit ? 'PUT' : 'POST';

    final payload = {
      'sku': sku.trim().toUpperCase(),
      'name': name.trim(),
      'category': category,
      'unit': unit.trim().isEmpty ? 'Pcs' : unit.trim(),
    };

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify(
          method: method,
          endpoint: endpoint,
          payload: payload,
          closeSheet: true,
        );
        return;
      }

      final token = await _getToken();
      final url = '$baseUrl$endpoint';
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(payload);

      final response = isEdit
          ? await http
              .put(Uri.parse(url), headers: headers, body: body)
              .timeout(requestTimeout)
          : await http
              .post(Uri.parse(url), headers: headers, body: body)
              .timeout(requestTimeout);

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        Get.back();
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Data produk disimpan.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        fetchProducts();
      } else {
        String errorMsg = data['message'] ?? 'Gagal menyimpan produk.';
        if (data['errors'] != null) {
          errorMsg = data['errors'].values.first[0].toString();
        }
        Get.snackbar('Gagal', errorMsg,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);
      }
    } catch (e) {
      await _saveOfflineAndNotify(
        method: method,
        endpoint: endpoint,
        payload: payload,
        closeSheet: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==========================================
  // DELETE PRODUK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> deleteProduct(int id) async {
    final endpoint = '/products/$id';

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify(
          method: 'DELETE',
          endpoint: endpoint,
          payload: {},
          closeSheet: false,
        );
        return;
      }

      final token = await _getToken();
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(requestTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Terhapus',
          data['message'] ?? 'Produk berhasil dihapus.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        fetchProducts();
      } else {
        Get.snackbar(
          'Gagal Menghapus',
          data['message'] ?? 'Produk tidak dapat dihapus.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      await _saveOfflineAndNotify(
        method: 'DELETE',
        endpoint: endpoint,
        payload: {},
        closeSheet: false,
      );
    }
  }

  Future<void> _saveOfflineAndNotify({
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
    required bool closeSheet,
  }) async {
    await LocalDatabaseService.instance.addToSyncQueue(
      method: method,
      endpoint: endpoint,
      payload: jsonEncode(payload),
      module: 'product',
    );
    await syncService.refreshPendingCount();
    await _loadProductsFromCache(search: searchQuery.value.trim());

    if (closeSheet) Get.back();

    Get.snackbar(
      'Tersimpan Offline',
      'Koneksi tidak stabil. Perubahan produk disimpan di HP & akan otomatis terkirim saat internet lancar.',
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      icon: const Icon(Icons.cloud_off, color: Colors.amber),
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}