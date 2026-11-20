import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'local_database_service.dart';

class SyncService extends GetxService {
  var isOnline = true.obs;
  var isSyncing = false.obs;
  var pendingCount = 0.obs;

  // Trigger reaktif agar controller lain tahu saat sinkronisasi selesai
  var lastSyncedAt = ''.obs;

  final String baseUrl = "https://berlianmandiriperkasa.vercel.app/api/api";
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  Future<SyncService> init() async {
    await refreshPendingCount();

    // Cek status awal
    final initial = await Connectivity().checkConnectivity();
    _updateConnectionStatus(initial);

    // Pantau perubahan jaringan secara real-time
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });

    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final connected = results.any((r) => r != ConnectivityResult.none);
    isOnline.value = connected;

    if (connected && pendingCount.value > 0) {
      syncPendingQueue();
    }
  }

  Future<void> refreshPendingCount() async {
    pendingCount.value = await LocalDatabaseService.instance.getPendingCount();
  }

  Future<void> syncPendingQueue() async {
    if (isSyncing.value || !isOnline.value) return;

    final queue = await LocalDatabaseService.instance.getPendingQueue();
    if (queue.isEmpty) {
      pendingCount.value = 0;
      return;
    }

    isSyncing.value = true;
    int syncedCount = 0;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) return;

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      for (final item in queue) {
        final int id = item['id'];
        final String method = item['method'];
        final String endpoint = item['endpoint'];
        final String payload = item['payload'];
        final uri = Uri.parse('$baseUrl$endpoint');

        try {
          http.Response response;

          if (method == 'POST') {
            response = await http
                .post(uri, headers: headers, body: payload)
                .timeout(const Duration(seconds: 10));
          } else if (method == 'PUT') {
            response = await http
                .put(uri, headers: headers, body: payload)
                .timeout(const Duration(seconds: 10));
          } else if (method == 'DELETE') {
            response = await http
                .delete(uri, headers: headers)
                .timeout(const Duration(seconds: 10));
          } else {
            continue;
          }

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Berhasil masuk MySQL -> hapus dari antrean offline
            await LocalDatabaseService.instance.removeFromSyncQueue(id);
            syncedCount++;
          } else if (response.statusCode >= 400 && response.statusCode < 500) {
            // Error validasi permanen (misal stok tidak cukup) -> hapus agar tidak menyumbat antrean
            await LocalDatabaseService.instance.removeFromSyncQueue(id);
            debugPrint('Sync item #$id ditolak server (${response.statusCode}): ${response.body}');
          } else {
            // Error server 5xx -> hentikan sementara, coba lagi nanti
            break;
          }
        } catch (e) {
          // Jaringan putus/timeout di tengah jalan -> hentikan loop agar urutan FIFO tetap terjaga
          debugPrint('Sync tertunda karena jaringan: $e');
          break;
        }
      }
    } finally {
      isSyncing.value = false;
      await refreshPendingCount();

      if (syncedCount > 0) {
        lastSyncedAt.value = DateTime.now().toIso8601String();
        Get.snackbar(
          'Sinkronisasi Selesai',
          '$syncedCount data offline berhasil dipindahkan ke Server.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          icon: const Icon(Icons.cloud_done, color: Colors.green),
        );
      }
    }
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    super.onClose();
  }
}