import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isDetailLoading = false.obs;
  var isSubmitting = false.obs;

  var products = [].obs;
  var categories = <String>[].obs;
  var searchQuery = ''.obs;

  // State untuk halaman Detail Kartu Stok
  var productDetail = Rxn();

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Helper format Rupiah aman untuk String/int/double/null
  String formatRupiah(dynamic value) {
    final numVal = double.tryParse(value?.toString() ?? '0') ?? 0;
    final intVal = numVal.round();
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

  Future<void> fetchProducts({String? search}) async {
    isLoading.value = true;
    try {
      final token = await _getToken();
      final q = search ?? searchQuery.value;
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: q.isNotEmpty ? {'search': q} : null,
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          products.value = data['data']['products'] ?? [];
          categories.value = List<String>.from(data['data']['categories'] ?? []);
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat daftar produk',
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Gangguan Jaringan', 'Periksa koneksi internet Anda',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetail(int id) async {
    isDetailLoading.value = true;
    productDetail.value = null;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          productDetail.value = data['data'];
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat detail kartu stok',
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Gangguan Jaringan', 'Tidak dapat terhubung ke server',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> saveProduct({
    int? id,
    required String sku,
    required String name,
    required String category,
    required String unit,
  }) async {
    isSubmitting.value = true;
    try {
      final token = await _getToken();
      final isEdit = id != null;
      final url = isEdit ? '$baseUrl/products/$id' : '$baseUrl/products';

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'sku': sku.trim().toUpperCase(),
        'name': name.trim(),
        'category': category,
        'unit': unit.trim().isEmpty ? 'Pcs' : unit.trim(),
      });

      final response = isEdit
          ? await http.put(Uri.parse(url), headers: headers, body: body)
          : await http.post(Uri.parse(url), headers: headers, body: body);

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        Get.back(); // Tutup BottomSheet
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
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi ke server',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

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
      Get.snackbar('Error', 'Kesalahan koneksi ke server',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}