import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/approval_controller.dart';

void logout() async {
  // Hapus sesi lokal
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

  // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
  // ...

  // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
  Get.offAllNamed(Routes.LOGIN);
}

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key});

  String _formatRp(dynamic number) {
    if (number == null) return "Rp 0";
    double parsedNumber = 0;
    if (number is String) {
      parsedNumber = double.tryParse(number) ?? 0;
    } else if (number is num) {
      parsedNumber = number.toDouble();
    }
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(parsedNumber);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApprovalController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate-100
      appBar: AppBar(
        title: const Text('Pusat Persetujuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Keluar',
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi Keluar",
                middleText: "Anda yakin ingin keluar dari sistem?",
                textCancel: "Batal",
                textConfirm: "Ya, Keluar",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => logout(),
              );
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.pendingDocuments.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
        }

        if (controller.pendingDocuments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade300),
                const SizedBox(height: 16),
                const Text('Meja kerja Anda bersih!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 8),
                Text('Tidak ada dokumen menunggu persetujuan.',
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchApprovals,
          color: const Color(0xFF10B981), // Emerald-500
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.pendingDocuments.length,
            itemBuilder: (context, index) {
              final doc = controller.pendingDocuments[index];
              final isSO = doc['doc_type_code'] == 'SO';

              return Card(
                elevation: 2,
                shadowColor: Colors.black12,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Kartu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSO ? Colors.indigo.shade50 : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              doc['doc_type'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSO ? Colors.indigo.shade700 : Colors.orange.shade700,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(DateTime.parse(doc['date'])),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Isi Kartu (Referensi & Nominal)
                      Text(doc['reference_no'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text(doc['person'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, thickness: 1),
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Nilai Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                          Text(_formatRp(doc['amount']), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tombol Aksi
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.isProcessing.value ? null : () => controller.confirmAction(doc['reject_url'], false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                side: BorderSide(color: Colors.red.shade200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.isProcessing.value ? null : () => controller.confirmAction(doc['approve_url'], true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981), // Emerald
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}