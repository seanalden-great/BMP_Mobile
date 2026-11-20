// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/dashboard_controller.dart';

// void logout() async {
//   // Hapus sesi lokal
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');

//   // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//   // ...

//   // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//   Get.offAllNamed(Routes.LOGIN);
// }

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key});

//   // FUNGSI YANG DIPERBAIKI: Konversi otomatis jika backend mengirim String
//   String _formatRp(dynamic number) {
//     if (number == null) return "Rp 0";

//     double parsedNumber = 0;
//     if (number is String) {
//       parsedNumber = double.tryParse(number) ?? 0;
//     } else if (number is num) {
//       parsedNumber = number.toDouble();
//     }

//     return NumberFormat.currency(
//             locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
//         .format(parsedNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(DashboardController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9), // Slate-100
//       appBar: AppBar(
//         title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
//         if (controller.isLoading.value && controller.summary.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         final sum = controller.summary;

//         return RefreshIndicator(
//           onRefresh: controller.fetchDashboardData,
//           color: const Color(0xFF2563EB),
//           child: ListView(
//             padding: const EdgeInsets.all(20.0),
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Dashboard',
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B)),
//                       ),
//                       Text(
//                         sum['bulan'] ?? 'Bulan Berjalan',
//                         style: const TextStyle(
//                             color: Color(0xFF64748B),
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                   CircleAvatar(
//                     backgroundColor: const Color(0xFF2563EB),
//                     child: IconButton(
//                       icon: const Icon(Icons.sync, color: Colors.white),
//                       onPressed: controller.fetchDashboardData,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // KPI Progress Bar Target
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Target Penjualan',
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF94A3B8))),
//                         Text('${sum['persentase_target'] ?? 0}%',
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFF2563EB))),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: (sum['persentase_target'] ?? 0) / 100.0,
//                       backgroundColor: const Color(0xFFF1F5F9),
//                       color: const Color(0xFF2563EB),
//                       minHeight: 10,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                         '${_formatRp(sum['pendapatan'])} / ${_formatRp(sum['target_penjualan'])}',
//                         style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Kartu Saldo Kas & Net Profit
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [Color(0xFF1E293B), Color(0xFF334155)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4))
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('SALDO KAS & BANK',
//                               style: TextStyle(
//                                   color: Color(0xFF94A3B8),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 1.0)),
//                           const SizedBox(height: 8),
//                           Text(_formatRp(sum['saldo_kas']),
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w900)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [Color(0xFF4F46E5), Color(0xFF2563EB)]),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Text('MARGIN',
//                               style: TextStyle(
//                                   color: Color(0xFFC7D2FE),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           Text('${sum['profit_margin'] ?? 0}%',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w900)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Grid Pendapatan & Pengeluaran
//               Row(
//                 children: [
//                   Expanded(
//                       child: _buildSummaryCard(
//                           'Pendapatan',
//                           _formatRp(sum['pendapatan']),
//                           Icons.arrow_upward,
//                           const Color(0xFF10B981))),
//                   const SizedBox(width: 12),
//                   Expanded(
//                       child: _buildSummaryCard(
//                           'Pengeluaran',
//                           _formatRp(sum['pengeluaran']),
//                           Icons.arrow_downward,
//                           const Color(0xFFEF4444))),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // Section List: Top Customers & Low Stocks
//               const Text('Wawasan Bisnis',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),

//               _buildSectionTitle('Pelanggan Terbaik', Icons.star, Colors.amber),
//               ...controller.topCustomers.map((c) => _buildListTile(
//                   c['contact'] != null ? c['contact']['name'] : 'Umum',
//                   _formatRp(c['total_spent']),
//                   'Total Pembelanjaan')),

//               const SizedBox(height: 12),
//               _buildSectionTitle(
//                   'Stok Menipis', Icons.warning_amber_rounded, Colors.orange),
//               // ...controller.lowStocks.map((s) => _buildListTile(s['name'], '${s['total_stock']} ${s['unit'] ?? ''}', 'Sisa Tersedia')),
//               ...controller.lowStocks.map((s) => _buildListTile(
//                   s['name'],
//                   '${s['total_stock'] ?? 0} ${s['unit'] ?? ''}',
//                   'Sisa Tersedia')),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildSummaryCard(
//       String title, String amount, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(height: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF64748B),
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(amount,
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w900,
//                   color: Color(0xFF1E293B))),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, IconData icon, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF475569))),
//         ],
//       ),
//     );
//   }

//   Widget _buildListTile(String title, String trailing, String subtitle) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFF1F5F9)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF334155)),
//                   overflow: TextOverflow.ellipsis)),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(trailing,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w900,
//                       color: Color(0xFF0F172A))),
//               Text(subtitle,
//                   style: const TextStyle(
//                       fontSize: 9,
//                       color: Color(0xFF94A3B8),
//                       fontWeight: FontWeight.bold)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/dashboard_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key});

//   String _formatRp(double number) {
//     return NumberFormat.currency(
//             locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
//         .format(number);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(DashboardController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: const Text('Home',
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
//       body: Obx(() {
//         final sum = controller.summary.value;
//         if (controller.isLoading.value && sum == null) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchDashboardData,
//           color: const Color(0xFF2563EB),
//           child: ListView(
//             padding: const EdgeInsets.all(20.0),
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Dashboard',
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B)),
//                       ),
//                       Text(
//                         sum?.bulan ?? 'Bulan Berjalan',
//                         style: const TextStyle(
//                             color: Color(0xFF64748B),
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                   CircleAvatar(
//                     backgroundColor: const Color(0xFF2563EB),
//                     child: IconButton(
//                       icon: const Icon(Icons.sync, color: Colors.white),
//                       onPressed: controller.fetchDashboardData,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // KPI Progress Bar Target
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Target Penjualan',
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF94A3B8))),
//                         Text('${sum?.persentaseTarget ?? 0}%',
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFF2563EB))),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: sum?.targetProgress ?? 0.0,
//                       backgroundColor: const Color(0xFFF1F5F9),
//                       color: const Color(0xFF2563EB),
//                       minHeight: 10,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                         '${_formatRp(sum?.pendapatan ?? 0)} / ${_formatRp(sum?.targetPenjualan ?? 0)}',
//                         style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Kartu Saldo Kas & Net Profit
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [Color(0xFF1E293B), Color(0xFF334155)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4))
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('SALDO KAS & BANK',
//                               style: TextStyle(
//                                   color: Color(0xFF94A3B8),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 1.0)),
//                           const SizedBox(height: 8),
//                           Text(_formatRp(sum?.saldoKas ?? 0),
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w900)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [Color(0xFF4F46E5), Color(0xFF2563EB)]),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Text('MARGIN',
//                               style: TextStyle(
//                                   color: Color(0xFFC7D2FE),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           Text('${sum?.profitMargin ?? 0}%',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w900)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Grid Pendapatan & Pengeluaran
//               Row(
//                 children: [
//                   Expanded(
//                       child: _buildSummaryCard(
//                           'Pendapatan',
//                           _formatRp(sum?.pendapatan ?? 0),
//                           Icons.arrow_upward,
//                           const Color(0xFF10B981))),
//                   const SizedBox(width: 12),
//                   Expanded(
//                       child: _buildSummaryCard(
//                           'Pengeluaran',
//                           _formatRp(sum?.pengeluaran ?? 0),
//                           Icons.arrow_downward,
//                           const Color(0xFFEF4444))),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // Section List: Top Customers & Low Stocks
//               const Text('Wawasan Bisnis',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),

//               _buildSectionTitle('Pelanggan Terbaik', Icons.star, Colors.amber),
//               ...controller.topCustomers.map((c) => _buildListTile(
//                   c.name, _formatRp(c.totalSpent), 'Total Pembelanjaan')),

//               const SizedBox(height: 12),
//               _buildSectionTitle(
//                   'Stok Menipis', Icons.warning_amber_rounded, Colors.orange),
//               ...controller.lowStocks.map((s) => _buildListTile(
//                   s.name, '${s.totalStock} ${s.unit}', 'Sisa Tersedia')),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildSummaryCard(
//       String title, String amount, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(height: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF64748B),
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(amount,
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w900,
//                   color: Color(0xFF1E293B))),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, IconData icon, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF475569))),
//         ],
//       ),
//     );
//   }

//   Widget _buildListTile(String title, String trailing, String subtitle) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFF1F5F9)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF334155)),
//                   overflow: TextOverflow.ellipsis)),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(trailing,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w900,
//                       color: Color(0xFF0F172A))),
//               Text(subtitle,
//                   style: const TextStyle(
//                       fontSize: 9,
//                       color: Color(0xFF94A3B8),
//                       fontWeight: FontWeight.bold)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/dashboard_controller.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  String _formatRp(double number) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(number);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
              color: online ? Colors.amber.shade100 : Colors.red.shade100,
              child: Row(
                children: [
                  Icon(
                    online ? Icons.cloud_upload : Icons.wifi_off,
                    size: 18,
                    color: online ? Colors.amber.shade900 : Colors.red.shade900,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      !online
                          ? 'Mode Offline (${sync.pendingCount.value} antrean tersimpan di HP)'
                          : '${sync.pendingCount.value} data offline menunggu sinkronisasi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: online
                            ? Colors.amber.shade900
                            : Colors.red.shade900,
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
                      child: const Text('Sync',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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

          // Konten Dashboard
          Expanded(
            child: Obx(() {
              final sum = controller.summary.value;
              if (controller.isLoading.value && sum == null) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              return RefreshIndicator(
                onRefresh: controller.fetchDashboardData,
                color: const Color(0xFF2563EB),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B)),
                            ),
                            Text(
                              sum?.bulan ?? 'Bulan Berjalan',
                              style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF2563EB),
                          child: IconButton(
                            icon: const Icon(Icons.sync, color: Colors.white),
                            onPressed: controller.fetchDashboardData,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // KPI Progress Bar Target
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Target Penjualan',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF94A3B8))),
                              Text('${sum?.persentaseTarget ?? 0}%',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2563EB))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: sum?.targetProgress ?? 0.0,
                            backgroundColor: const Color(0xFFF1F5F9),
                            color: const Color(0xFF2563EB),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              '${_formatRp(sum?.pendapatan ?? 0)} / ${_formatRp(sum?.targetPenjualan ?? 0)}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu Saldo Kas & Net Profit
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E293B),
                                    Color(0xFF334155)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SALDO KAS & BANK',
                                    style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0)),
                                const SizedBox(height: 8),
                                Text(_formatRp(sum?.saldoKas ?? 0),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF4F46E5),
                                Color(0xFF2563EB)
                              ]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('MARGIN',
                                    style: TextStyle(
                                        color: Color(0xFFC7D2FE),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('${sum?.profitMargin ?? 0}%',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid Pendapatan & Pengeluaran
                    Row(
                      children: [
                        Expanded(
                            child: _buildSummaryCard(
                                'Pendapatan',
                                _formatRp(sum?.pendapatan ?? 0),
                                Icons.arrow_upward,
                                const Color(0xFF10B981))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildSummaryCard(
                                'Pengeluaran',
                                _formatRp(sum?.pengeluaran ?? 0),
                                Icons.arrow_downward,
                                const Color(0xFFEF4444))),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section List: Top Customers & Low Stocks
                    const Text('Wawasan Bisnis',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),

                    _buildSectionTitle(
                        'Pelanggan Terbaik', Icons.star, Colors.amber),
                    ...controller.topCustomers.map((c) => _buildListTile(
                        c.name, _formatRp(c.totalSpent), 'Total Pembelanjaan')),

                    const SizedBox(height: 12),
                    _buildSectionTitle('Stok Menipis',
                        Icons.warning_amber_rounded, Colors.orange),
                    ...controller.lowStocks.map((s) => _buildListTile(
                        s.name, '${s.totalStock} ${s.unit}', 'Sisa Tersedia')),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(amount,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String trailing, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155)),
                  overflow: TextOverflow.ellipsis)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trailing,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A))),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}