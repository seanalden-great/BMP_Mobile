// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/approval_controller.dart';

// void logout() async {
//   // Hapus sesi lokal
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');

//   // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//   // ...

//   // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ApprovalView extends StatelessWidget {
//   const ApprovalView({super.key});

//   String _formatRp(dynamic number) {
//     if (number == null) return "Rp 0";
//     double parsedNumber = 0;
//     if (number is String) {
//       parsedNumber = double.tryParse(number) ?? 0;
//     } else if (number is num) {
//       parsedNumber = number.toDouble();
//     }
//     return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(parsedNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ApprovalController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9), // Slate-100
//       appBar: AppBar(
//         title: const Text('Pusat Persetujuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: const Color(0xFF1E293B),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             tooltip: 'Keluar',
//             onPressed: () {
//               Get.defaultDialog(
//                 title: "Konfirmasi Keluar",
//                 middleText: "Anda yakin ingin keluar dari sistem?",
//                 textCancel: "Batal",
//                 textConfirm: "Ya, Keluar",
//                 confirmTextColor: Colors.white,
//                 buttonColor: Colors.red,
//                 onConfirm: () => logout(),
//               );
//             },
//           )
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.pendingDocuments.isEmpty) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
//         }

//         if (controller.pendingDocuments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade300),
//                 const SizedBox(height: 16),
//                 const Text('Meja kerja Anda bersih!',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                 const SizedBox(height: 8),
//                 Text('Tidak ada dokumen menunggu persetujuan.',
//                     style: TextStyle(color: Colors.grey.shade600)),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchApprovals,
//           color: const Color(0xFF10B981), // Emerald-500
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: controller.pendingDocuments.length,
//             itemBuilder: (context, index) {
//               final doc = controller.pendingDocuments[index];
//               final isSO = doc['doc_type_code'] == 'SO';

//               return Card(
//                 elevation: 2,
//                 shadowColor: Colors.black12,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header Kartu
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: isSO ? Colors.indigo.shade50 : Colors.orange.shade50,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               doc['doc_type'],
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: isSO ? Colors.indigo.shade700 : Colors.orange.shade700,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             DateFormat('dd MMM yyyy').format(DateTime.parse(doc['date'])),
//                             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
                      
//                       // Isi Kartu (Referensi & Nominal)
//                       Text(doc['reference_no'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
//                       const SizedBox(height: 4),
//                       Text(doc['person'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                      
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Divider(height: 1, thickness: 1),
//                       ),
                      
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Nilai Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
//                           Text(_formatRp(doc['amount']), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Tombol Aksi
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton.icon(
//                               onPressed: controller.isProcessing.value ? null : () => controller.confirmAction(doc['reject_url'], false),
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: Colors.red.shade600,
//                                 side: BorderSide(color: Colors.red.shade200),
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               ),
//                               icon: const Icon(Icons.close, size: 18),
//                               label: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: controller.isProcessing.value ? null : () => controller.confirmAction(doc['approve_url'], true),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF10B981), // Emerald
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               ),
//                               icon: const Icon(Icons.check, size: 18),
//                               label: const Text('Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/approval_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ApprovalView extends StatelessWidget {
//   const ApprovalView({super.key});

//   String _formatRp(double number) {
//     return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
//         .format(number);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ApprovalController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: const Text('Pusat Persetujuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: const Color(0xFF1E293B),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             tooltip: 'Keluar',
//             onPressed: () {
//               Get.defaultDialog(
//                 title: "Konfirmasi Keluar",
//                 middleText: "Anda yakin ingin keluar dari sistem?",
//                 textCancel: "Batal",
//                 textConfirm: "Ya, Keluar",
//                 confirmTextColor: Colors.white,
//                 buttonColor: Colors.red,
//                 onConfirm: () => logout(),
//               );
//             },
//           )
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.pendingDocuments.isEmpty) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
//         }

//         if (controller.pendingDocuments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade300),
//                 const SizedBox(height: 16),
//                 const Text('Meja kerja Anda bersih!',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                 const SizedBox(height: 8),
//                 Text('Tidak ada dokumen menunggu persetujuan.',
//                     style: TextStyle(color: Colors.grey.shade600)),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchApprovals,
//           color: const Color(0xFF10B981),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: controller.pendingDocuments.length,
//             itemBuilder: (context, index) {
//               final doc = controller.pendingDocuments[index];
//               final parsedDate = DateTime.tryParse(doc.date);

//               return Card(
//                 elevation: 2,
//                 shadowColor: Colors.black12,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header Kartu
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: doc.isSO ? Colors.indigo.shade50 : Colors.orange.shade50,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               doc.docType,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: doc.isSO ? Colors.indigo.shade700 : Colors.orange.shade700,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             parsedDate != null
//                                 ? DateFormat('dd MMM yyyy').format(parsedDate)
//                                 : doc.date,
//                             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Isi Kartu (Referensi & Nominal)
//                       Text(doc.referenceNo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
//                       const SizedBox(height: 4),
//                       Text(doc.person, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),

//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Divider(height: 1, thickness: 1),
//                       ),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Nilai Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
//                           Text(_formatRp(doc.amount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Tombol Aksi
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton.icon(
//                               onPressed: controller.isProcessing.value
//                                   ? null
//                                   : () => controller.confirmAction(doc.rejectUrl, false),
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: Colors.red.shade600,
//                                 side: BorderSide(color: Colors.red.shade200),
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               ),
//                               icon: const Icon(Icons.close, size: 18),
//                               label: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: controller.isProcessing.value
//                                   ? null
//                                   : () => controller.confirmAction(doc.approveUrl, true),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF10B981),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               ),
//                               icon: const Icon(Icons.check, size: 18),
//                               label: const Text('Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/approval_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ApprovalView extends StatelessWidget {
//   const ApprovalView({super.key});

//   String _formatRp(double number) {
//     return NumberFormat.currency(
//             locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
//         .format(number);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ApprovalController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: const Text('Pusat Persetujuan',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: const Color(0xFF1E293B),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             tooltip: 'Keluar',
//             onPressed: () {
//               Get.defaultDialog(
//                 title: "Konfirmasi Keluar",
//                 middleText: "Anda yakin ingin keluar dari sistem?",
//                 textCancel: "Batal",
//                 textConfirm: "Ya, Keluar",
//                 confirmTextColor: Colors.white,
//                 buttonColor: Colors.red,
//                 onConfirm: () => logout(),
//               );
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // Banner Status Offline / Antrean Sinkronisasi
//           Obx(() {
//             final sync = controller.syncService;
//             if (sync.isOnline.value && sync.pendingCount.value == 0) {
//               return const SizedBox.shrink();
//             }

//             final bool online = sync.isOnline.value;
//             return Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               color: online ? Colors.amber.shade100 : Colors.red.shade100,
//               child: Row(
//                 children: [
//                   Icon(
//                     online ? Icons.cloud_upload : Icons.wifi_off,
//                     size: 18,
//                     color: online ? Colors.amber.shade900 : Colors.red.shade900,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       !online
//                           ? 'Mode Offline (${sync.pendingCount.value} antrean tersimpan di HP)'
//                           : '${sync.pendingCount.value} data offline menunggu sinkronisasi',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: online
//                             ? Colors.amber.shade900
//                             : Colors.red.shade900,
//                       ),
//                     ),
//                   ),
//                   if (online && !sync.isSyncing.value)
//                     TextButton(
//                       onPressed: sync.syncPendingQueue,
//                       style: TextButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         minimumSize: const Size(50, 28),
//                       ),
//                       child: const Text('Sync',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                   if (sync.isSyncing.value)
//                     const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                 ],
//               ),
//             );
//           }),

//           // Daftar Dokumen Menunggu Persetujuan
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value &&
//                   controller.pendingDocuments.isEmpty) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF10B981)));
//               }

//               if (controller.pendingDocuments.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.check_circle_outline,
//                           size: 80, color: Colors.green.shade300),
//                       const SizedBox(height: 16),
//                       const Text('Meja kerja Anda bersih!',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1E293B))),
//                       const SizedBox(height: 8),
//                       Text('Tidak ada dokumen menunggu persetujuan.',
//                           style: TextStyle(color: Colors.grey.shade600)),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchApprovals,
//                 color: const Color(0xFF10B981),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: controller.pendingDocuments.length,
//                   itemBuilder: (context, index) {
//                     final doc = controller.pendingDocuments[index];
//                     final parsedDate = DateTime.tryParse(doc.date);

//                     return Card(
//                       elevation: 2,
//                       shadowColor: Colors.black12,
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         side: doc.isPendingSync
//                             ? BorderSide(color: Colors.amber.shade400, width: 1.5)
//                             : BorderSide.none,
//                       ),
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Header Kartu
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: doc.isSO
//                                         ? Colors.indigo.shade50
//                                         : Colors.orange.shade50,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     doc.docType,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: doc.isSO
//                                           ? Colors.indigo.shade700
//                                           : Colors.orange.shade700,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   parsedDate != null
//                                       ? DateFormat('dd MMM yyyy')
//                                           .format(parsedDate)
//                                       : doc.date,
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey.shade500),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),

//                             // Isi Kartu (Referensi & Nominal)
//                             Text(doc.referenceNo,
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w900,
//                                     color: Color(0xFF0F172A))),
//                             const SizedBox(height: 4),
//                             Text(doc.person,
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey.shade600)),

//                             const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               child: Divider(height: 1, thickness: 1),
//                             ),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('Nilai Transaksi',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF94A3B8))),
//                                 Text(_formatRp(doc.amount),
//                                     style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w900,
//                                         color: Color(0xFF10B981))),
//                               ],
//                             ),
//                             const SizedBox(height: 16),

//                             // Tombol Aksi / Status Menunggu Sync
//                             if (doc.isPendingSync)
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.amber.shade50,
//                                   borderRadius: BorderRadius.circular(10),
//                                   border:
//                                       Border.all(color: Colors.amber.shade300),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.cloud_upload_outlined,
//                                         size: 16, color: Colors.amber.shade900),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'Menunggu Sync (${doc.pendingStatus})',
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.amber.shade900,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: OutlinedButton.icon(
//                                       onPressed: controller.isProcessing.value
//                                           ? null
//                                           : () => controller.confirmAction(
//                                               doc.rejectUrl, false),
//                                       style: OutlinedButton.styleFrom(
//                                         foregroundColor: Colors.red.shade600,
//                                         side: BorderSide(
//                                             color: Colors.red.shade200),
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ),
//                                       icon: const Icon(Icons.close, size: 18),
//                                       label: const Text('Tolak',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: ElevatedButton.icon(
//                                       onPressed: controller.isProcessing.value
//                                           ? null
//                                           : () => controller.confirmAction(
//                                               doc.approveUrl, true),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             const Color(0xFF10B981),
//                                         foregroundColor: Colors.white,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ),
//                                       icon: const Icon(Icons.check, size: 18),
//                                       label: const Text('Setujui',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:bmp_mobile/services/language_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/approval_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ApprovalView extends StatelessWidget {
//   const ApprovalView({super.key});

//   String _formatRp(double number) {
//     return NumberFormat.currency(
//             locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
//         .format(number);
//   }

//   String _translatePendingStatus(String? status) {
//     if (status == 'Disetujui') return 'appr_status_approved'.tr;
//     if (status == 'Ditolak') return 'appr_status_rejected'.tr;
//     return status ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ApprovalController());
//     final langService = Get.find<LanguageService>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: Text('appr_title'.tr,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           Obx(() => TextButton(
//                 onPressed: langService.toggleLanguage,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     langService.isIndonesian ? 'ID' : 'EN',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               )),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             tooltip: 'logout'.tr,
//             onPressed: () {
//               Get.defaultDialog(
//                 title: 'logout_confirm_title'.tr,
//                 middleText: 'logout_confirm_msg'.tr,
//                 textCancel: 'cancel'.tr,
//                 textConfirm: 'yes_logout'.tr,
//                 confirmTextColor: Colors.white,
//                 buttonColor: Colors.red,
//                 onConfirm: () => logout(),
//               );
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // Banner Status Offline / Antrean Sinkronisasi
//           Obx(() {
//             final sync = controller.syncService;
//             if (sync.isOnline.value && sync.pendingCount.value == 0) {
//               return const SizedBox.shrink();
//             }

//             final bool online = sync.isOnline.value;
//             return Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               color: online ? Colors.amber.shade100 : Colors.red.shade100,
//               child: Row(
//                 children: [
//                   Icon(
//                     online ? Icons.cloud_upload : Icons.wifi_off,
//                     size: 18,
//                     color: online ? Colors.amber.shade900 : Colors.red.shade900,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       !online
//                           ? 'offline_mode_queue'.trParams(
//                               {'count': '${sync.pendingCount.value}'})
//                           : 'pending_sync_msg'.trParams(
//                               {'count': '${sync.pendingCount.value}'}),
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: online
//                             ? Colors.amber.shade900
//                             : Colors.red.shade900,
//                       ),
//                     ),
//                   ),
//                   if (online && !sync.isSyncing.value)
//                     TextButton(
//                       onPressed: sync.syncPendingQueue,
//                       style: TextButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         minimumSize: const Size(50, 28),
//                       ),
//                       child: Text('sync'.tr,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                   if (sync.isSyncing.value)
//                     const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                 ],
//               ),
//             );
//           }),

//           // Daftar Dokumen Menunggu Persetujuan
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value &&
//                   controller.pendingDocuments.isEmpty) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF10B981)));
//               }

//               if (controller.pendingDocuments.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.check_circle_outline,
//                           size: 80, color: Colors.green.shade300),
//                       const SizedBox(height: 16),
//                       Text('appr_empty_title'.tr,
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1E293B))),
//                       const SizedBox(height: 8),
//                       Text('appr_empty_sub'.tr,
//                           style: TextStyle(color: Colors.grey.shade600)),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchApprovals,
//                 color: const Color(0xFF10B981),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: controller.pendingDocuments.length,
//                   itemBuilder: (context, index) {
//                     final doc = controller.pendingDocuments[index];
//                     final parsedDate = DateTime.tryParse(doc.date);

//                     return Card(
//                       elevation: 2,
//                       shadowColor: Colors.black12,
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         side: doc.isPendingSync
//                             ? BorderSide(color: Colors.amber.shade400, width: 1.5)
//                             : BorderSide.none,
//                       ),
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Header Kartu
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: doc.isSO
//                                         ? Colors.indigo.shade50
//                                         : Colors.orange.shade50,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     doc.docType,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: doc.isSO
//                                           ? Colors.indigo.shade700
//                                           : Colors.orange.shade700,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   parsedDate != null
//                                       ? DateFormat('dd MMM yyyy')
//                                           .format(parsedDate)
//                                       : doc.date,
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey.shade500),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),

//                             // Isi Kartu (Referensi & Nominal)
//                             Text(doc.referenceNo,
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w900,
//                                     color: Color(0xFF0F172A))),
//                             const SizedBox(height: 4),
//                             Text(doc.person,
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey.shade600)),

//                             const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               child: Divider(height: 1, thickness: 1),
//                             ),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('appr_tx_value'.tr,
//                                     style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF94A3B8))),
//                                 Text(_formatRp(doc.amount),
//                                     style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w900,
//                                         color: Color(0xFF10B981))),
//                               ],
//                             ),
//                             const SizedBox(height: 16),

//                             // Tombol Aksi / Status Menunggu Sync
//                             if (doc.isPendingSync)
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.amber.shade50,
//                                   borderRadius: BorderRadius.circular(10),
//                                   border:
//                                       Border.all(color: Colors.amber.shade300),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.cloud_upload_outlined,
//                                         size: 16, color: Colors.amber.shade900),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'appr_waiting_sync_status'.trParams({
//                                         'status': _translatePendingStatus(
//                                             doc.pendingStatus),
//                                       }),
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.amber.shade900,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: OutlinedButton.icon(
//                                       onPressed: controller.isProcessing.value
//                                           ? null
//                                           : () => controller.confirmAction(
//                                               doc.rejectUrl, false),
//                                       style: OutlinedButton.styleFrom(
//                                         foregroundColor: Colors.red.shade600,
//                                         side: BorderSide(
//                                             color: Colors.red.shade200),
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ),
//                                       icon: const Icon(Icons.close, size: 18),
//                                       label: Text('appr_reject'.tr,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: ElevatedButton.icon(
//                                       onPressed: controller.isProcessing.value
//                                           ? null
//                                           : () => controller.confirmAction(
//                                               doc.approveUrl, true),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             const Color(0xFF10B981),
//                                         foregroundColor: Colors.white,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ),
//                                       icon: const Icon(Icons.check, size: 18),
//                                       label: Text('appr_approve'.tr,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:bmp_mobile/services/language_service.dart';
import 'package:bmp_mobile/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/approval_controller.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key});

  String _formatRp(double number) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(number);
  }

  String _translatePendingStatus(String? status) {
    if (status == 'Disetujui') return 'appr_status_approved'.tr;
    if (status == 'Ditolak') return 'appr_status_rejected'.tr;
    return status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApprovalController());
    final langService = Get.find<LanguageService>();
    final themeService = Get.find<ThemeService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Palet warna dinamis
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('appr_title'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor:
            isDark ? const Color(0xFF1E293B) : const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol Ganti Tema (Dark / Light Mode)
          Obx(() => IconButton(
                icon: Icon(
                  themeService.isDarkMode.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                tooltip: themeService.isDarkMode.value
                    ? 'Light Mode'
                    : 'Dark Mode',
                onPressed: themeService.toggleTheme,
              )),
          // Tombol Ganti Bahasa (ID / EN)
          Obx(() => TextButton(
                onPressed: langService.toggleLanguage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    langService.isIndonesian ? 'ID' : 'EN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'logout'.tr,
            onPressed: () {
              Get.defaultDialog(
                title: 'logout_confirm_title'.tr,
                middleText: 'logout_confirm_msg'.tr,
                textCancel: 'cancel'.tr,
                textConfirm: 'yes_logout'.tr,
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => logout(),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Banner Status Offline / Antrean Sinkronisasi
          Obx(() {
            final sync = controller.syncService;
            if (sync.isOnline.value && sync.pendingCount.value == 0) {
              return const SizedBox.shrink();
            }

            final bool online = sync.isOnline.value;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: online
                  ? (isDark
                      ? Colors.amber.shade900.withOpacity(0.3)
                      : Colors.amber.shade100)
                  : (isDark
                      ? Colors.red.shade900.withOpacity(0.3)
                      : Colors.red.shade100),
              child: Row(
                children: [
                  Icon(
                    online ? Icons.cloud_upload : Icons.wifi_off,
                    size: 18,
                    color: online
                        ? (isDark
                            ? Colors.amber.shade300
                            : Colors.amber.shade900)
                        : (isDark ? Colors.red.shade300 : Colors.red.shade900),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      !online
                          ? 'offline_mode_queue'.trParams(
                              {'count': '${sync.pendingCount.value}'})
                          : 'pending_sync_msg'.trParams(
                              {'count': '${sync.pendingCount.value}'}),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: online
                            ? (isDark
                                ? Colors.amber.shade200
                                : Colors.amber.shade900)
                            : (isDark
                                ? Colors.red.shade200
                                : Colors.red.shade900),
                      ),
                    ),
                  ),
                  if (online && !sync.isSyncing.value)
                    TextButton(
                      onPressed: sync.syncPendingQueue,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(50, 28),
                      ),
                      child: Text('sync'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  if (sync.isSyncing.value)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            );
          }),

          // Daftar Dokumen Menunggu Persetujuan
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.pendingDocuments.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF10B981)));
              }

              if (controller.pendingDocuments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 80,
                          color: isDark
                              ? Colors.green.shade400
                              : Colors.green.shade300),
                      const SizedBox(height: 16),
                      Text('appr_empty_title'.tr,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                      const SizedBox(height: 8),
                      Text('appr_empty_sub'.tr,
                          style: TextStyle(color: textSecondary)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchApprovals,
                color: const Color(0xFF10B981),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.pendingDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = controller.pendingDocuments[index];
                    final parsedDate = DateTime.tryParse(doc.date);

                    return Card(
                      elevation: isDark ? 0 : 2,
                      shadowColor: Colors.black12,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: doc.isPendingSync
                            ? BorderSide(
                                color: Colors.amber.shade400, width: 1.5)
                            : (isDark
                                ? BorderSide(color: borderColor)
                                : BorderSide.none),
                      ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: doc.isSO
                                        ? (isDark
                                            ? Colors.indigo.shade900
                                                .withOpacity(0.45)
                                            : Colors.indigo.shade50)
                                        : (isDark
                                            ? Colors.orange.shade900
                                                .withOpacity(0.45)
                                            : Colors.orange.shade50),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    doc.docType,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: doc.isSO
                                          ? (isDark
                                              ? Colors.indigo.shade300
                                              : Colors.indigo.shade700)
                                          : (isDark
                                              ? Colors.orange.shade300
                                              : Colors.orange.shade700),
                                    ),
                                  ),
                                ),
                                Text(
                                  parsedDate != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(parsedDate)
                                      : doc.date,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Isi Kartu (Referensi & Nominal)
                            Text(doc.referenceNo,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: textPrimary)),
                            const SizedBox(height: 4),
                            Text(doc.person,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textSecondary)),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Divider(
                                  height: 1, thickness: 1, color: borderColor),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('appr_tx_value'.tr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: textSecondary)),
                                Text(_formatRp(doc.amount),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: isDark
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFF10B981))),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Tombol Aksi / Status Menunggu Sync
                            if (doc.isPendingSync)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.amber.shade900.withOpacity(0.3)
                                      : Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: isDark
                                          ? Colors.amber.shade700
                                          : Colors.amber.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined,
                                        size: 16,
                                        color: isDark
                                            ? Colors.amber.shade300
                                            : Colors.amber.shade900),
                                    const SizedBox(width: 8),
                                    Text(
                                      'appr_waiting_sync_status'.trParams({
                                        'status': _translatePendingStatus(
                                            doc.pendingStatus),
                                      }),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.amber.shade200
                                            : Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: controller.isProcessing.value
                                          ? null
                                          : () => controller.confirmAction(
                                              doc.rejectUrl, false),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isDark
                                            ? Colors.red.shade300
                                            : Colors.red.shade600,
                                        side: BorderSide(
                                            color: isDark
                                                ? Colors.red.shade400
                                                    .withOpacity(0.5)
                                                : Colors.red.shade200),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.close, size: 18),
                                      label: Text('appr_reject'.tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: controller.isProcessing.value
                                          ? null
                                          : () => controller.confirmAction(
                                              doc.approveUrl, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.check, size: 18),
                                      label: Text('appr_approve'.tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
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
          ),
        ],
      ),
    );
  }
}