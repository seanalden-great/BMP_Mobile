// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ApprovalController extends GetxController {
//   var isLoading = true.obs;
//   var isProcessing = false.obs;
//   var pendingDocuments = [].obs;

//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/approvals";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchApprovals();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Mengambil daftar dokumen yang butuh persetujuan
//   Future<void> fetchApprovals() async {
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
//           pendingDocuments.value = data['data'];
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Koneksi Gagal', 'Tidak dapat mengambil antrean persetujuan.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Memproses Persetujuan / Penolakan Tunggal
//   Future<void> processDocument(String url, bool isApprove) async {
//     isProcessing.value = true;
//     final actionText = isApprove ? 'menyetujui' : 'menolak';

//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Sukses',
//           'Dokumen berhasil di$actionText.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//         );
//         fetchApprovals(); // Segarkan daftar setelah berhasil
//       } else {
//         Get.snackbar('Gagal', 'Terjadi kesalahan sistem.',
//             backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Kesalahan koneksi ke server.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isProcessing.value = false;
//     }
//   }

//   // Dialog Konfirmasi sebelum memproses
//   void confirmAction(String url, bool isApprove) {
//     final actionText = isApprove ? 'Setujui' : 'Tolak';
//     final actionColor = isApprove ? Colors.green.shade700 : Colors.red.shade700;

//     Get.defaultDialog(
//       title: "Konfirmasi",
//       middleText: "Anda yakin ingin $actionText dokumen ini?",
//       textCancel: "Batal",
//       textConfirm: "Ya, $actionText",
//       confirmTextColor: Colors.white,
//       buttonColor: actionColor,
//       onConfirm: () {
//         Get.back(); // Tutup dialog
//         processDocument(url, isApprove);
//       },
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/approval.dart'; // <-- Impor Model

// class ApprovalController extends GetxController {
//   var isLoading = true.obs;
//   var isProcessing = false.obs;
//   var pendingDocuments = <Approval>[].obs; // <-- Sudah menggunakan tipe Model

//   final String apiUrl = "https://berlianmandiriperkasa.vercel.app/api/api/approvals";

//   @override
//   void onInit() {
//     super.onInit();
//     fetchApprovals();
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Mengambil daftar dokumen yang butuh persetujuan
//   Future<void> fetchApprovals() async {
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
//           final List rawList = data['data'] ?? [];
//           pendingDocuments.value = rawList
//               .map((item) => Approval.fromJson(item))
//               .toList();
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Koneksi Gagal', 'Tidak dapat mengambil antrean persetujuan.',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // // Memproses Persetujuan / Penolakan Tunggal
//   // Future<void> processDocument(String url, bool isApprove) async {
//   //   isProcessing.value = true;
//   //   final actionText = isApprove ? 'menyetujui' : 'menolak';

//   //   try {
//   //     final token = await _getToken();
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {
//   //         'Authorization': 'Bearer $token',
//   //         'Accept': 'application/json',
//   //       },
//   //     );

//   //     if (response.statusCode == 200) {
//   //       Get.snackbar(
//   //         'Sukses',
//   //         'Dokumen berhasil di$actionText.',
//   //         backgroundColor: Colors.green.shade100,
//   //         colorText: Colors.green.shade900,
//   //       );
//   //       fetchApprovals();
//   //     } else {
//   //       Get.snackbar('Gagal', 'Terjadi kesalahan sistem.',
//   //           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar('Error', 'Kesalahan koneksi ke server.',
//   //         backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//   //   } finally {
//   //     isProcessing.value = false;
//   //   }
//   // }

//   Future<void> processDocument(String url, bool isApprove) async {
//     isProcessing.value = true;
//     final actionText = isApprove ? 'menyetujui' : 'menolak';

//     try {
//       final token = await _getToken();
//       debugPrint('=== POST APPROVAL URL: $url ===');

//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       debugPrint('=== STATUS: ${response.statusCode} ===');
//       debugPrint('=== BODY: ${response.body} ===');

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Sukses',
//           'Dokumen berhasil di$actionText.',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//         );
//         fetchApprovals();
//       } else {
//         // Coba ambil pesan error asli dari JSON Laravel
//         String serverMsg = 'HTTP ${response.statusCode}';
//         try {
//           final body = jsonDecode(response.body);
//           if (body['message'] != null) {
//             serverMsg = 'HTTP ${response.statusCode}: ${body['message']}';
//           }
//         } catch (_) {}

//         Get.snackbar(
//           'Gagal',
//           serverMsg,
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           duration: const Duration(seconds: 5),
//         );
//       }
//     } catch (e) {
//       debugPrint('=== EXCEPTION: $e ===');
//       Get.snackbar('Error', 'Kesalahan koneksi: $e',
//           backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//     } finally {
//       isProcessing.value = false;
//     }
//   }

//   // Dialog Konfirmasi sebelum memproses
//   void confirmAction(String url, bool isApprove) {
//     final actionText = isApprove ? 'Setujui' : 'Tolak';
//     final actionColor = isApprove ? Colors.green.shade700 : Colors.red.shade700;

//     Get.defaultDialog(
//       title: "Konfirmasi",
//       middleText: "Anda yakin ingin $actionText dokumen ini?",
//       textCancel: "Batal",
//       textConfirm: "Ya, $actionText",
//       confirmTextColor: Colors.white,
//       buttonColor: actionColor,
//       onConfirm: () {
//         Get.back();
//         processDocument(url, isApprove);
//       },
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/approval.dart';
import '../services/local_database_service.dart';
import '../services/sync_service.dart';

class ApprovalController extends GetxController {
  var isLoading = true.obs;
  var isProcessing = false.obs;
  var pendingDocuments = <Approval>[].obs;

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  final SyncService syncService = Get.find<SyncService>();
  final Duration requestTimeout = const Duration(seconds: 8);

  @override
  void onInit() {
    super.onInit();
    fetchApprovals();

    // Otomatis refresh daftar saat SyncService selesai mengirim data offline
    ever(syncService.lastSyncedAt, (_) {
      fetchApprovals();
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Konversi full URL dari API Laravel menjadi relative endpoint untuk SyncService
  String _toRelativeEndpoint(String fullUrl) {
    if (fullUrl.startsWith(baseUrl)) {
      return fullUrl.substring(baseUrl.length);
    }
    final uri = Uri.tryParse(fullUrl);
    if (uri != null && uri.path.isNotEmpty) {
      return uri.path.replaceFirst('/api/api', '').replaceFirst('/api', '');
    }
    return fullUrl;
  }

  // ==========================================
  // READ: ANTREAN PERSETUJUAN (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> fetchApprovals() async {
    isLoading.value = true;
    try {
      if (!syncService.isOnline.value) {
        await _loadApprovalsFromCache();
        return;
      }

      final token = await _getToken();
      final response = await http
          .get(
            Uri.parse('$baseUrl/approvals'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List rawList = data['data'] ?? [];
          await LocalDatabaseService.instance
              .saveCache('pending_approvals', jsonEncode(rawList));

          final docs = rawList.map((item) => Approval.fromJson(item)).toList();
          pendingDocuments.value = await _mergePendingActions(docs);
        }
      } else {
        await _loadApprovalsFromCache();
      }
    } catch (e) {
      // Koneksi putus / timeout -> baca dari SQLite
      await _loadApprovalsFromCache();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadApprovalsFromCache() async {
    final cached =
        await LocalDatabaseService.instance.getCache('pending_approvals');
    if (cached != null) {
      final List rawList = jsonDecode(cached);
      final docs = rawList.map((item) => Approval.fromJson(item)).toList();
      pendingDocuments.value = await _mergePendingActions(docs);
    }
  }

  // Tandai dokumen yang sudah diklik Setujui/Tolak saat offline
  Future<List<Approval>> _mergePendingActions(List<Approval> docs) async {
    final queue = await LocalDatabaseService.instance.getPendingQueue();
    final Map<String, String> queuedEndpoints = {};

    for (final item in queue) {
      if (item['module'] != 'approval') continue;
      final endpoint = item['endpoint']?.toString() ?? '';
      final isApprove = endpoint.contains('/approve');
      queuedEndpoints[endpoint] = isApprove ? 'Disetujui' : 'Ditolak';
    }

    return docs.map((doc) {
      final approvePath = _toRelativeEndpoint(doc.approveUrl);
      final rejectPath = _toRelativeEndpoint(doc.rejectUrl);

      if (queuedEndpoints.containsKey(approvePath)) {
        return doc.copyWith(pendingStatus: queuedEndpoints[approvePath]);
      } else if (queuedEndpoints.containsKey(rejectPath)) {
        return doc.copyWith(pendingStatus: queuedEndpoints[rejectPath]);
      }
      return doc;
    }).toList();
  }

  // ==========================================
  // ACTION: SETUJUI / TOLAK (ONLINE -> FALLBACK OFFLINE)
  // ==========================================
  Future<void> processDocument(String url, bool isApprove) async {
    isProcessing.value = true;
    final actionText = isApprove ? 'menyetujui' : 'menolak';

    try {
      if (!syncService.isOnline.value) {
        await _saveOfflineAndNotify(url, isApprove);
        return;
      }

      final token = await _getToken();
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Dokumen berhasil di$actionText.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        fetchApprovals();
      } else {
        String serverMsg = 'HTTP ${response.statusCode}';
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) {
            serverMsg = 'HTTP ${response.statusCode}: ${body['message']}';
          }
        } catch (_) {}

        Get.snackbar(
          'Gagal',
          serverMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      // Koneksi putus / timeout saat memproses -> simpan ke antrean SQLite
      await _saveOfflineAndNotify(url, isApprove);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _saveOfflineAndNotify(String url, bool isApprove) async {
    final relativeEndpoint = _toRelativeEndpoint(url);
    final label = isApprove ? 'Persetujuan' : 'Penolakan';

    await LocalDatabaseService.instance.addToSyncQueue(
      method: 'POST',
      endpoint: relativeEndpoint,
      payload: jsonEncode({}),
      module: 'approval',
    );
    await syncService.refreshPendingCount();
    await _loadApprovalsFromCache();

    Get.snackbar(
      'Tersimpan Offline',
      '$label disimpan di HP & akan otomatis terkirim saat internet lancar.',
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      icon: const Icon(Icons.cloud_off, color: Colors.amber),
      duration: const Duration(seconds: 4),
    );
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
        Get.back();
        processDocument(url, isApprove);
      },
    );
  }
}