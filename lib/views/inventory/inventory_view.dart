// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/inventory_controller.dart';

// void logout() async {
//     // Hapus sesi lokal
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
    
//     // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//     // ...

//     // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//     Get.offAllNamed(Routes.LOGIN);
//   }

// class InventoryView extends StatelessWidget {
//   const InventoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(InventoryController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text('Data Pergerakan Stok & Gudang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
//         if (controller.isLoading.value && controller.adjustments.isEmpty) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         if (controller.adjustments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.archive_outlined, size: 64, color: Colors.grey.shade400),
//                 const SizedBox(height: 16),
//                 Text('Belum ada riwayat stok & mutasi.', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchHistory,
//           color: const Color(0xFF2563EB),
//           child: ListView.builder(
//             padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 80),
//             itemCount: controller.adjustments.length,
//             itemBuilder: (context, index) {
//               final adj = controller.adjustments[index];
//               final isAdd = adj['type'] == 'Penambahan';
//               final isTransfer = adj['reason'].toString().contains('[MUTASI');

//               return Card(
//                 elevation: 0,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.grey.shade200),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: isTransfer ? Colors.blue.shade50 : (isAdd ? Colors.green.shade50 : Colors.red.shade50),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   isTransfer ? Icons.repeat : (isAdd ? Icons.arrow_upward : Icons.arrow_downward),
//                                   size: 14,
//                                   color: isTransfer ? Colors.blue.shade700 : (isAdd ? Colors.green.shade700 : Colors.red.shade700),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   isTransfer ? 'MUTASI STOK' : (isAdd ? 'TAMBAH' : 'KURANG'),
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     color: isTransfer ? Colors.blue.shade700 : (isAdd ? Colors.green.shade700 : Colors.red.shade700),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(adj['date'] ?? '-', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         '[${adj['product_sku']}] ${adj['product'] != null ? adj['product']['name'] : 'Produk Dihapus'}',
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Lokasi: ${adj['warehouse'] != null ? adj['warehouse']['name'] : 'Gudang Utama'}',
//                         style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//                       ),
//                       const Divider(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '"${adj['reason']}"',
//                               style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             '${adj['quantity']} ${adj['product'] != null ? adj['product']['unit'] : ''}',
//                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
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
      
//       // Mengubah FAB untuk memunculkan Pilihan Aksi
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showActionPicker(context, controller),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // --- LACI MENU (ACTION PICKER) ---
//   void _showActionPicker(BuildContext context, InventoryController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Pilih Tindakan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.inventory, color: Colors.teal.shade600)),
//               title: const Text('Stock Opname (Penyesuaian Fisik)', style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text('Cocokkan stok sistem dengan stok riil di gudang.'),
//               onTap: () {
//                 Get.back();
//                 _showAdjustmentForm(context, controller);
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.repeat, color: Colors.blue.shade600)),
//               title: const Text('Mutasi Antar Gudang', style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text('Pindahkan barang dari satu cabang ke cabang lain.'),
//               onTap: () {
//                 Get.back();
//                 _showTransferForm(context, controller);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- FORM STOCK OPNAME (SEBELUMNYA) ---
//   void _showAdjustmentForm(BuildContext context, InventoryController controller) {
//     String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
//     final qtyController = TextEditingController();
//     final reasonController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text('Form Penyesuaian Stok', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Lokasi Gudang', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                 items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
//                 onChanged: (val) => selectedWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Pilih Produk', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                 isExpanded: true,
//                 items: controller.products.map((p) => DropdownMenuItem<String>(value: p['sku'].toString(), child: Text('[${p['sku']}] ${p['name']}', style: const TextStyle(fontSize: 14)))).toList(),
//                 onChanged: (val) => selectedProductSku = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       decoration: InputDecoration(labelText: 'Tipe Mutasi', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                       items: const [
//                         DropdownMenuItem(value: 'Penambahan', child: Text('(+) Tambah', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
//                         DropdownMenuItem(value: 'Pengurangan', child: Text('(-) Kurang', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
//                       ],
//                       onChanged: (val) => selectedType = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 2,
//                     child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Kuantitas', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(controller: reasonController, maxLines: 2, decoration: InputDecoration(labelText: 'Alasan Penyesuaian', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                 onPressed: controller.isSubmitting.value ? null : () {
//                   if (selectedWarehouseId == null || selectedProductSku == null || qtyController.text.isEmpty) {
//                     Get.snackbar('Validasi Gagal', 'Mohon lengkapi Gudang, Produk, dan Kuantitas', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
//                     return;
//                   }
//                   controller.submitAdjustment(warehouseId: selectedWarehouseId!, productSku: selectedProductSku!, type: selectedType!, quantity: qtyController.text.trim(), reason: reasonController.text.trim().isEmpty ? 'Penyesuaian Fisik Lapangan' : reasonController.text.trim());
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                 child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan & Jurnal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- FORM BARU: MUTASI ANTAR GUDANG (TRANSFER) ---
//   void _showTransferForm(BuildContext context, InventoryController controller) {
//     String? fromWarehouseId, toWarehouseId, selectedProductSku;
//     final qtyController = TextEditingController();
//     final notesController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.repeat, color: Colors.blue.shade600),
//                   const SizedBox(width: 8),
//                   const Text('Transfer Antar Gudang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Gudang Asal (Keluar)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), fillColor: Colors.red.shade50, filled: true),
//                 items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
//                 onChanged: (val) => fromWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Gudang Tujuan (Masuk)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), fillColor: Colors.green.shade50, filled: true),
//                 items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
//                 onChanged: (val) => toWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(labelText: 'Pilih Produk', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                       isExpanded: true,
//                       items: controller.products.map((p) => DropdownMenuItem<String>(value: p['sku'].toString(), child: Text('[${p['sku']}] ${p['name']}', style: const TextStyle(fontSize: 14)))).toList(),
//                       onChanged: (val) => selectedProductSku = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Jumlah', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(controller: notesController, maxLines: 2, decoration: InputDecoration(labelText: 'Catatan Pengiriman (Nopol, Supir, dsb)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                 onPressed: controller.isSubmitting.value ? null : () {
//                   if (fromWarehouseId == null || toWarehouseId == null || selectedProductSku == null || qtyController.text.isEmpty) {
//                     Get.snackbar('Validasi Gagal', 'Lengkapi seluruh data wajib!', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
//                     return;
//                   }
//                   if (fromWarehouseId == toWarehouseId) {
//                     Get.snackbar('Kesalahan', 'Gudang Asal dan Tujuan tidak boleh sama.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
//                     return;
//                   }
//                   controller.submitTransfer(fromWarehouseId: fromWarehouseId!, toWarehouseId: toWarehouseId!, productSku: selectedProductSku!, quantity: qtyController.text.trim(), notes: notesController.text.trim());
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                 child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Proses Pindahkan Stok', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/inventory_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class InventoryView extends StatelessWidget {
//   const InventoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(InventoryController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text('Data Pergerakan Stok & Gudang',
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
//         if (controller.isLoading.value && controller.adjustments.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         if (controller.adjustments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.archive_outlined, size: 64, color: Colors.grey.shade400),
//                 const SizedBox(height: 16),
//                 Text('Belum ada riwayat stok & mutasi.',
//                     style: TextStyle(
//                         color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchHistory,
//           color: const Color(0xFF2563EB),
//           child: ListView.builder(
//             padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 80),
//             itemCount: controller.adjustments.length,
//             itemBuilder: (context, index) {
//               final adj = controller.adjustments[index];

//               return Card(
//                 elevation: 0,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.grey.shade200),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: adj.isTransfer
//                                   ? Colors.blue.shade50
//                                   : (adj.isAdd
//                                       ? Colors.green.shade50
//                                       : Colors.red.shade50),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   adj.isTransfer
//                                       ? Icons.repeat
//                                       : (adj.isAdd
//                                           ? Icons.arrow_upward
//                                           : Icons.arrow_downward),
//                                   size: 14,
//                                   color: adj.isTransfer
//                                       ? Colors.blue.shade700
//                                       : (adj.isAdd
//                                           ? Colors.green.shade700
//                                           : Colors.red.shade700),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   adj.isTransfer
//                                       ? 'MUTASI STOK'
//                                       : (adj.isAdd ? 'TAMBAH' : 'KURANG'),
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     color: adj.isTransfer
//                                         ? Colors.blue.shade700
//                                         : (adj.isAdd
//                                             ? Colors.green.shade700
//                                             : Colors.red.shade700),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(adj.date,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade500,
//                                   fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         '[${adj.productSku}] ${adj.productName}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: Color(0xFF1E293B)),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Lokasi: ${adj.warehouseName}',
//                         style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade600,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       const Divider(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '"${adj.reason}"',
//                               style: const TextStyle(
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.grey),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             '${adj.quantity} ${adj.productUnit}',
//                             style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFF0F172A)),
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showActionPicker(context, controller),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // --- LACI MENU (ACTION PICKER) ---
//   void _showActionPicker(BuildContext context, InventoryController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Pilih Tindakan',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.teal.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.inventory, color: Colors.teal.shade600)),
//               title: const Text('Stock Opname (Penyesuaian Fisik)',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text('Cocokkan stok sistem dengan stok riil di gudang.'),
//               onTap: () {
//                 Get.back();
//                 _showAdjustmentForm(context, controller);
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.repeat, color: Colors.blue.shade600)),
//               title: const Text('Mutasi Antar Gudang',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text('Pindahkan barang dari satu cabang ke cabang lain.'),
//               onTap: () {
//                 Get.back();
//                 _showTransferForm(context, controller);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- FORM STOCK OPNAME ---
//   void _showAdjustmentForm(BuildContext context, InventoryController controller) {
//     String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
//     final qtyController = TextEditingController();
//     final reasonController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text('Form Penyesuaian Stok',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B))),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Lokasi Gudang',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Pilih Produk',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                 isExpanded: true,
//                 items: controller.products
//                     .map((p) => DropdownMenuItem<String>(
//                         value: p.sku,
//                         child: Text('[${p.sku}] ${p.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedProductSku = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       decoration: InputDecoration(
//                           labelText: 'Tipe Mutasi',
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       items: const [
//                         DropdownMenuItem(
//                             value: 'Penambahan',
//                             child: Text('(+) Tambah',
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold))),
//                         DropdownMenuItem(
//                             value: 'Pengurangan',
//                             child: Text('(-) Kurang',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold))),
//                       ],
//                       onChanged: (val) => selectedType = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 2,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'Kuantitas',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: reasonController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'Alasan Penyesuaian',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (selectedWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar('Validasi Gagal',
//                                   'Mohon lengkapi Gudang, Produk, dan Kuantitas',
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             controller.submitAdjustment(
//                                 warehouseId: selectedWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 type: selectedType!,
//                                 quantity: qtyController.text.trim(),
//                                 reason: reasonController.text.trim().isEmpty
//                                     ? 'Penyesuaian Fisik Lapangan'
//                                     : reasonController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0D9488),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : const Text('Simpan & Jurnal',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- FORM MUTASI ANTAR GUDANG (TRANSFER) ---
//   void _showTransferForm(BuildContext context, InventoryController controller) {
//     String? fromWarehouseId, toWarehouseId, selectedProductSku;
//     final qtyController = TextEditingController();
//     final notesController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.repeat, color: Colors.blue.shade600),
//                   const SizedBox(width: 8),
//                   const Text('Transfer Antar Gudang',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E293B))),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Gudang Asal (Keluar)',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     fillColor: Colors.red.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => fromWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Gudang Tujuan (Masuk)',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     fillColor: Colors.green.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => toWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                           labelText: 'Pilih Produk',
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       isExpanded: true,
//                       items: controller.products
//                           .map((p) => DropdownMenuItem<String>(
//                               value: p.sku,
//                               child: Text('[${p.sku}] ${p.name}',
//                                   style: const TextStyle(fontSize: 14))))
//                           .toList(),
//                       onChanged: (val) => selectedProductSku = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'Jumlah',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: notesController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'Catatan Pengiriman (Nopol, Supir, dsb)',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (fromWarehouseId == null ||
//                                 toWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar(
//                                   'Validasi Gagal', 'Lengkapi seluruh data wajib!',
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             if (fromWarehouseId == toWarehouseId) {
//                               Get.snackbar('Kesalahan',
//                                   'Gudang Asal dan Tujuan tidak boleh sama.',
//                                   backgroundColor: Colors.red.shade100,
//                                   colorText: Colors.red.shade900);
//                               return;
//                             }
//                             controller.submitTransfer(
//                                 fromWarehouseId: fromWarehouseId!,
//                                 toWarehouseId: toWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 quantity: qtyController.text.trim(),
//                                 notes: notesController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2563EB),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : const Text('Proses Pindahkan Stok',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/inventory_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class InventoryView extends StatelessWidget {
//   const InventoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(InventoryController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text('Data Pergerakan Stok & Gudang',
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

//           // Daftar Riwayat Pergerakan Stok
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value &&
//                   controller.adjustments.isEmpty) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//               }

//               if (controller.adjustments.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.archive_outlined,
//                           size: 64, color: Colors.grey.shade400),
//                       const SizedBox(height: 16),
//                       Text('Belum ada riwayat stok & mutasi.',
//                           style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchHistory,
//                 color: const Color(0xFF2563EB),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(
//                       top: 8, left: 16, right: 16, bottom: 80),
//                   itemCount: controller.adjustments.length,
//                   itemBuilder: (context, index) {
//                     final adj = controller.adjustments[index];

//                     return Card(
//                       elevation: 0,
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                           color: adj.isPendingSync
//                               ? Colors.amber.shade400
//                               : Colors.grey.shade200,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: adj.isTransfer
//                                         ? Colors.blue.shade50
//                                         : (adj.isAdd
//                                             ? Colors.green.shade50
//                                             : Colors.red.shade50),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         adj.isTransfer
//                                             ? Icons.repeat
//                                             : (adj.isAdd
//                                                 ? Icons.arrow_upward
//                                                 : Icons.arrow_downward),
//                                         size: 14,
//                                         color: adj.isTransfer
//                                             ? Colors.blue.shade700
//                                             : (adj.isAdd
//                                                 ? Colors.green.shade700
//                                                 : Colors.red.shade700),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         adj.isTransfer
//                                             ? 'MUTASI STOK'
//                                             : (adj.isAdd ? 'TAMBAH' : 'KURANG'),
//                                         style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                           color: adj.isTransfer
//                                               ? Colors.blue.shade700
//                                               : (adj.isAdd
//                                                   ? Colors.green.shade700
//                                                   : Colors.red.shade700),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     if (adj.isPendingSync) ...[
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 6, vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber.shade100,
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: Text(
//                                           'Menunggu Sync',
//                                           style: TextStyle(
//                                             fontSize: 9,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.amber.shade900,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                     ],
//                                     Text(adj.date,
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey.shade500,
//                                             fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               '[${adj.productSku}] ${adj.productName}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                   color: Color(0xFF1E293B)),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Lokasi: ${adj.warehouseName}',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey.shade600,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             const Divider(height: 24),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     '"${adj.reason}"',
//                                     style: const TextStyle(
//                                         fontSize: 12,
//                                         fontStyle: FontStyle.italic,
//                                         color: Colors.grey),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${adj.quantity} ${adj.productUnit}',
//                                   style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w900,
//                                       color: Color(0xFF0F172A)),
//                                 ),
//                               ],
//                             ),
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showActionPicker(context, controller),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // --- LACI MENU (ACTION PICKER) ---
//   void _showActionPicker(BuildContext context, InventoryController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Pilih Tindakan',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.teal.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.inventory, color: Colors.teal.shade600)),
//               title: const Text('Stock Opname (Penyesuaian Fisik)',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle:
//                   const Text('Cocokkan stok sistem dengan stok riil di gudang.'),
//               onTap: () {
//                 Get.back();
//                 _showAdjustmentForm(context, controller);
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.repeat, color: Colors.blue.shade600)),
//               title: const Text('Mutasi Antar Gudang',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text(
//                   'Pindahkan barang dari satu cabang ke cabang lain.'),
//               onTap: () {
//                 Get.back();
//                 _showTransferForm(context, controller);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- FORM STOCK OPNAME ---
//   void _showAdjustmentForm(
//       BuildContext context, InventoryController controller) {
//     String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
//     final qtyController = TextEditingController();
//     final reasonController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text('Form Penyesuaian Stok',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B))),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Lokasi Gudang',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12)),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Pilih Produk',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12)),
//                 isExpanded: true,
//                 items: controller.products
//                     .map((p) => DropdownMenuItem<String>(
//                         value: p.sku,
//                         child: Text('[${p.sku}] ${p.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedProductSku = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       decoration: InputDecoration(
//                           labelText: 'Tipe Mutasi',
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       items: const [
//                         DropdownMenuItem(
//                             value: 'Penambahan',
//                             child: Text('(+) Tambah',
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold))),
//                         DropdownMenuItem(
//                             value: 'Pengurangan',
//                             child: Text('(-) Kurang',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold))),
//                       ],
//                       onChanged: (val) => selectedType = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 2,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'Kuantitas',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: reasonController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'Alasan Penyesuaian',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (selectedWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar('Validasi Gagal',
//                                   'Mohon lengkapi Gudang, Produk, dan Kuantitas',
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             controller.submitAdjustment(
//                                 warehouseId: selectedWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 type: selectedType!,
//                                 quantity: qtyController.text.trim(),
//                                 reason: reasonController.text.trim().isEmpty
//                                     ? 'Penyesuaian Fisik Lapangan'
//                                     : reasonController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0D9488),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : const Text('Simpan & Jurnal',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- FORM MUTASI ANTAR GUDANG (TRANSFER) ---
//   void _showTransferForm(BuildContext context, InventoryController controller) {
//     String? fromWarehouseId, toWarehouseId, selectedProductSku;
//     final qtyController = TextEditingController();
//     final notesController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.repeat, color: Colors.blue.shade600),
//                   const SizedBox(width: 8),
//                   const Text('Transfer Antar Gudang',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E293B))),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Gudang Asal (Keluar)',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     fillColor: Colors.red.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => fromWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'Gudang Tujuan (Masuk)',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     fillColor: Colors.green.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => toWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                           labelText: 'Pilih Produk',
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       isExpanded: true,
//                       items: controller.products
//                           .map((p) => DropdownMenuItem<String>(
//                               value: p.sku,
//                               child: Text('[${p.sku}] ${p.name}',
//                                   style: const TextStyle(fontSize: 14))))
//                           .toList(),
//                       onChanged: (val) => selectedProductSku = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'Jumlah',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: notesController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'Catatan Pengiriman (Nopol, Supir, dsb)',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (fromWarehouseId == null ||
//                                 toWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar('Validasi Gagal',
//                                   'Lengkapi seluruh data wajib!',
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             if (fromWarehouseId == toWarehouseId) {
//                               Get.snackbar('Kesalahan',
//                                   'Gudang Asal dan Tujuan tidak boleh sama.',
//                                   backgroundColor: Colors.red.shade100,
//                                   colorText: Colors.red.shade900);
//                               return;
//                             }
//                             controller.submitTransfer(
//                                 fromWarehouseId: fromWarehouseId!,
//                                 toWarehouseId: toWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 quantity: qtyController.text.trim(),
//                                 notes: notesController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2563EB),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : const Text('Proses Pindahkan Stok',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:bmp_mobile/services/language_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/inventory_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class InventoryView extends StatelessWidget {
//   const InventoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(InventoryController());
//     final langService = Get.find<LanguageService>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: Text('inv_title'.tr,
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

//           // Daftar Riwayat Pergerakan Stok
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value &&
//                   controller.adjustments.isEmpty) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//               }

//               if (controller.adjustments.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.archive_outlined,
//                           size: 64, color: Colors.grey.shade400),
//                       const SizedBox(height: 16),
//                       Text('inv_empty_history'.tr,
//                           style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchHistory,
//                 color: const Color(0xFF2563EB),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(
//                       top: 8, left: 16, right: 16, bottom: 80),
//                   itemCount: controller.adjustments.length,
//                   itemBuilder: (context, index) {
//                     final adj = controller.adjustments[index];

//                     return Card(
//                       elevation: 0,
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                           color: adj.isPendingSync
//                               ? Colors.amber.shade400
//                               : Colors.grey.shade200,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: adj.isTransfer
//                                         ? Colors.blue.shade50
//                                         : (adj.isAdd
//                                             ? Colors.green.shade50
//                                             : Colors.red.shade50),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         adj.isTransfer
//                                             ? Icons.repeat
//                                             : (adj.isAdd
//                                                 ? Icons.arrow_upward
//                                                 : Icons.arrow_downward),
//                                         size: 14,
//                                         color: adj.isTransfer
//                                             ? Colors.blue.shade700
//                                             : (adj.isAdd
//                                                 ? Colors.green.shade700
//                                                 : Colors.red.shade700),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         adj.isTransfer
//                                             ? 'inv_badge_transfer'.tr
//                                             : (adj.isAdd
//                                                 ? 'inv_badge_add'.tr
//                                                 : 'inv_badge_sub'.tr),
//                                         style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                           color: adj.isTransfer
//                                               ? Colors.blue.shade700
//                                               : (adj.isAdd
//                                                   ? Colors.green.shade700
//                                                   : Colors.red.shade700),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     if (adj.isPendingSync) ...[
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 6, vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber.shade100,
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: Text(
//                                           'waiting_sync'.tr,
//                                           style: TextStyle(
//                                             fontSize: 9,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.amber.shade900,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                     ],
//                                     Text(adj.date,
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey.shade500,
//                                             fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               '[${adj.productSku}] ${adj.productName}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                   color: Color(0xFF1E293B)),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'inv_location'
//                                   .trParams({'name': adj.warehouseName}),
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey.shade600,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             const Divider(height: 24),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     '"${adj.reason}"',
//                                     style: const TextStyle(
//                                         fontSize: 12,
//                                         fontStyle: FontStyle.italic,
//                                         color: Colors.grey),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${adj.quantity} ${adj.productUnit}',
//                                   style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w900,
//                                       color: Color(0xFF0F172A)),
//                                 ),
//                               ],
//                             ),
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showActionPicker(context, controller),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // --- LACI MENU (ACTION PICKER) ---
//   void _showActionPicker(BuildContext context, InventoryController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text('inv_choose_action'.tr,
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.teal.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.inventory, color: Colors.teal.shade600)),
//               title: Text('inv_opname_title'.tr,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text('inv_opname_sub'.tr),
//               onTap: () {
//                 Get.back();
//                 _showAdjustmentForm(context, controller);
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Icon(Icons.repeat, color: Colors.blue.shade600)),
//               title: Text('inv_transfer_title'.tr,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text('inv_transfer_sub'.tr),
//               onTap: () {
//                 Get.back();
//                 _showTransferForm(context, controller);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- FORM STOCK OPNAME ---
//   void _showAdjustmentForm(
//       BuildContext context, InventoryController controller) {
//     String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
//     final qtyController = TextEditingController();
//     final reasonController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text('inv_adj_form_title'.tr,
//                   style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B))),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'inv_warehouse_loc'.tr,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12)),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'inv_select_product'.tr,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12)),
//                 isExpanded: true,
//                 items: controller.products
//                     .map((p) => DropdownMenuItem<String>(
//                         value: p.sku,
//                         child: Text('[${p.sku}] ${p.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => selectedProductSku = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       decoration: InputDecoration(
//                           labelText: 'inv_mutation_type'.tr,
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       items: [
//                         DropdownMenuItem(
//                             value: 'Penambahan',
//                             child: Text('inv_type_add'.tr,
//                                 style: const TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold))),
//                         DropdownMenuItem(
//                             value: 'Pengurangan',
//                             child: Text('inv_type_sub'.tr,
//                                 style: const TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold))),
//                       ],
//                       onChanged: (val) => selectedType = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 2,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'inv_quantity'.tr,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: reasonController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'inv_adj_reason'.tr,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (selectedWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar('validation_failed'.tr,
//                                   'inv_adj_validation_msg'.tr,
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             controller.submitAdjustment(
//                                 warehouseId: selectedWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 type: selectedType!,
//                                 quantity: qtyController.text.trim(),
//                                 reason: reasonController.text.trim().isEmpty
//                                     ? 'inv_default_reason'.tr
//                                     : reasonController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0D9488),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : Text('inv_save_journal'.tr,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- FORM MUTASI ANTAR GUDANG (TRANSFER) ---
//   void _showTransferForm(BuildContext context, InventoryController controller) {
//     String? fromWarehouseId, toWarehouseId, selectedProductSku;
//     final qtyController = TextEditingController();
//     final notesController = TextEditingController();

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.repeat, color: Colors.blue.shade600),
//                   const SizedBox(width: 8),
//                   Text('inv_transfer_form_title'.tr,
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E293B))),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'inv_from_warehouse'.tr,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     fillColor: Colors.red.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => fromWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: 'inv_to_warehouse'.tr,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     fillColor: Colors.green.shade50,
//                     filled: true),
//                 items: controller.warehouses
//                     .map((wh) => DropdownMenuItem<String>(
//                         value: wh.id.toString(),
//                         child: Text('[${wh.code}] ${wh.name}',
//                             style: const TextStyle(fontSize: 14))))
//                     .toList(),
//                 onChanged: (val) => toWarehouseId = val,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                           labelText: 'inv_select_product'.tr,
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12)),
//                       isExpanded: true,
//                       items: controller.products
//                           .map((p) => DropdownMenuItem<String>(
//                               value: p.sku,
//                               child: Text('[${p.sku}] ${p.name}',
//                                   style: const TextStyle(fontSize: 14))))
//                           .toList(),
//                       onChanged: (val) => selectedProductSku = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                         controller: qtyController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             labelText: 'inv_amount_qty'.tr,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                   controller: notesController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                       labelText: 'inv_transfer_notes'.tr,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)))),
//               const SizedBox(height: 24),
//               Obx(() => ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () {
//                             if (fromWarehouseId == null ||
//                                 toWarehouseId == null ||
//                                 selectedProductSku == null ||
//                                 qtyController.text.isEmpty) {
//                               Get.snackbar('validation_failed'.tr,
//                                   'inv_transfer_validation_msg'.tr,
//                                   backgroundColor: Colors.amber.shade100,
//                                   colorText: Colors.amber.shade900);
//                               return;
//                             }
//                             if (fromWarehouseId == toWarehouseId) {
//                               Get.snackbar('error_title'.tr,
//                                   'inv_same_warehouse_err'.tr,
//                                   backgroundColor: Colors.red.shade100,
//                                   colorText: Colors.red.shade900);
//                               return;
//                             }
//                             controller.submitTransfer(
//                                 fromWarehouseId: fromWarehouseId!,
//                                 toWarehouseId: toWarehouseId!,
//                                 productSku: selectedProductSku!,
//                                 quantity: qtyController.text.trim(),
//                                 notes: notesController.text.trim());
//                           },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2563EB),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     child: controller.isSubmitting.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : Text('inv_process_transfer'.tr,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                   )),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:bmp_mobile/services/language_service.dart';
import 'package:bmp_mobile/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/inventory_controller.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventoryController());
    final langService = Get.find<LanguageService>();
    final themeService = Get.find<ThemeService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Palet warna dinamis
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('inv_title'.tr,
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

          // Daftar Riwayat Pergerakan Stok
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.adjustments.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              if (controller.adjustments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.archive_outlined,
                          size: 64,
                          color: isDark
                              ? const Color(0xFF475569)
                              : Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('inv_empty_history'.tr,
                          style: TextStyle(
                              color: textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchHistory,
                color: const Color(0xFF2563EB),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 80),
                  itemCount: controller.adjustments.length,
                  itemBuilder: (context, index) {
                    final adj = controller.adjustments[index];

                    return Card(
                      elevation: 0,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: adj.isPendingSync
                              ? Colors.amber.shade400
                              : borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: adj.isTransfer
                                        ? (isDark
                                            ? Colors.blue.shade900
                                                .withOpacity(0.4)
                                            : Colors.blue.shade50)
                                        : (adj.isAdd
                                            ? (isDark
                                                ? Colors.green.shade900
                                                    .withOpacity(0.4)
                                                : Colors.green.shade50)
                                            : (isDark
                                                ? Colors.red.shade900
                                                    .withOpacity(0.4)
                                                : Colors.red.shade50)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        adj.isTransfer
                                            ? Icons.repeat
                                            : (adj.isAdd
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward),
                                        size: 14,
                                        color: adj.isTransfer
                                            ? (isDark
                                                ? Colors.blue.shade300
                                                : Colors.blue.shade700)
                                            : (adj.isAdd
                                                ? (isDark
                                                    ? Colors.green.shade300
                                                    : Colors.green.shade700)
                                                : (isDark
                                                    ? Colors.red.shade300
                                                    : Colors.red.shade700)),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        adj.isTransfer
                                            ? 'inv_badge_transfer'.tr
                                            : (adj.isAdd
                                                ? 'inv_badge_add'.tr
                                                : 'inv_badge_sub'.tr),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: adj.isTransfer
                                              ? (isDark
                                                  ? Colors.blue.shade300
                                                  : Colors.blue.shade700)
                                              : (adj.isAdd
                                                  ? (isDark
                                                      ? Colors.green.shade300
                                                      : Colors.green.shade700)
                                                  : (isDark
                                                      ? Colors.red.shade300
                                                      : Colors.red.shade700)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (adj.isPendingSync) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.amber.shade900
                                                  .withOpacity(0.5)
                                              : Colors.amber.shade100,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'waiting_sync'.tr,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.amber.shade200
                                                : Colors.amber.shade900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(adj.date,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: textSecondary,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '[${adj.productSku}] ${adj.productName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'inv_location'
                                  .trParams({'name': adj.warehouseName}),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500),
                            ),
                            Divider(height: 24, color: borderColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '"${adj.reason}"',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: textSecondary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${adj.quantity} ${adj.productUnit}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: textPrimary),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActionPicker(context, controller),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- LACI MENU (ACTION PICKER) ---
  void _showActionPicker(BuildContext context, InventoryController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('inv_choose_action'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isDark
                          ? Colors.teal.shade900.withOpacity(0.4)
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.inventory,
                      color:
                          isDark ? Colors.teal.shade300 : Colors.teal.shade600)),
              title: Text('inv_opname_title'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textPrimary)),
              subtitle: Text('inv_opname_sub'.tr,
                  style: TextStyle(color: textSecondary)),
              onTap: () {
                Get.back();
                _showAdjustmentForm(context, controller);
              },
            ),
            Divider(color: isDark ? const Color(0xFF334155) : null),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue.shade900.withOpacity(0.4)
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.repeat,
                      color:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade600)),
              title: Text('inv_transfer_title'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textPrimary)),
              subtitle: Text('inv_transfer_sub'.tr,
                  style: TextStyle(color: textSecondary)),
              onTap: () {
                Get.back();
                _showTransferForm(context, controller);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- FORM STOCK OPNAME ---
  void _showAdjustmentForm(
      BuildContext context, InventoryController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);

    String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
    final qtyController = TextEditingController();
    final reasonController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('inv_adj_form_title'.tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: sheetBg,
                decoration: InputDecoration(
                    labelText: 'inv_warehouse_loc'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12)),
                items: controller.warehouses
                    .map((wh) => DropdownMenuItem<String>(
                        value: wh.id.toString(),
                        child: Text('[${wh.code}] ${wh.name}',
                            style: const TextStyle(fontSize: 14))))
                    .toList(),
                onChanged: (val) => selectedWarehouseId = val,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: sheetBg,
                decoration: InputDecoration(
                    labelText: 'inv_select_product'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12)),
                isExpanded: true,
                items: controller.products
                    .map((p) => DropdownMenuItem<String>(
                        value: p.sku,
                        child: Text('[${p.sku}] ${p.name}',
                            style: const TextStyle(fontSize: 14))))
                    .toList(),
                onChanged: (val) => selectedProductSku = val,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: sheetBg,
                      value: selectedType,
                      decoration: InputDecoration(
                          labelText: 'inv_mutation_type'.tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12)),
                      items: [
                        DropdownMenuItem(
                            value: 'Penambahan',
                            child: Text('inv_type_add'.tr,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                        DropdownMenuItem(
                            value: 'Pengurangan',
                            child: Text('inv_type_sub'.tr,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (val) => selectedType = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'inv_quantity'.tr,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: 'inv_adj_reason'.tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                            if (selectedWarehouseId == null ||
                                selectedProductSku == null ||
                                qtyController.text.isEmpty) {
                              Get.snackbar('validation_failed'.tr,
                                  'inv_adj_validation_msg'.tr,
                                  backgroundColor: Colors.amber.shade100,
                                  colorText: Colors.amber.shade900);
                              return;
                            }
                            controller.submitAdjustment(
                                warehouseId: selectedWarehouseId!,
                                productSku: selectedProductSku!,
                                type: selectedType!,
                                quantity: qtyController.text.trim(),
                                reason: reasonController.text.trim().isEmpty
                                    ? 'inv_default_reason'.tr
                                    : reasonController.text.trim());
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text('inv_save_journal'.tr,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- FORM MUTASI ANTAR GUDANG (TRANSFER) ---
  void _showTransferForm(BuildContext context, InventoryController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);

    String? fromWarehouseId, toWarehouseId, selectedProductSku;
    final qtyController = TextEditingController();
    final notesController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.repeat,
                      color:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text('inv_transfer_form_title'.tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: sheetBg,
                decoration: InputDecoration(
                    labelText: 'inv_from_warehouse'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    fillColor: isDark
                        ? Colors.red.shade900.withOpacity(0.25)
                        : Colors.red.shade50,
                    filled: true),
                items: controller.warehouses
                    .map((wh) => DropdownMenuItem<String>(
                        value: wh.id.toString(),
                        child: Text('[${wh.code}] ${wh.name}',
                            style: const TextStyle(fontSize: 14))))
                    .toList(),
                onChanged: (val) => fromWarehouseId = val,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: sheetBg,
                decoration: InputDecoration(
                    labelText: 'inv_to_warehouse'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    fillColor: isDark
                        ? Colors.green.shade900.withOpacity(0.25)
                        : Colors.green.shade50,
                    filled: true),
                items: controller.warehouses
                    .map((wh) => DropdownMenuItem<String>(
                        value: wh.id.toString(),
                        child: Text('[${wh.code}] ${wh.name}',
                            style: const TextStyle(fontSize: 14))))
                    .toList(),
                onChanged: (val) => toWarehouseId = val,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: sheetBg,
                      decoration: InputDecoration(
                          labelText: 'inv_select_product'.tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12)),
                      isExpanded: true,
                      items: controller.products
                          .map((p) => DropdownMenuItem<String>(
                              value: p.sku,
                              child: Text('[${p.sku}] ${p.name}',
                                  style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (val) => selectedProductSku = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'inv_amount_qty'.tr,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: 'inv_transfer_notes'.tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                            if (fromWarehouseId == null ||
                                toWarehouseId == null ||
                                selectedProductSku == null ||
                                qtyController.text.isEmpty) {
                              Get.snackbar('validation_failed'.tr,
                                  'inv_transfer_validation_msg'.tr,
                                  backgroundColor: Colors.amber.shade100,
                                  colorText: Colors.amber.shade900);
                              return;
                            }
                            if (fromWarehouseId == toWarehouseId) {
                              Get.snackbar('error_title'.tr,
                                  'inv_same_warehouse_err'.tr,
                                  backgroundColor: Colors.red.shade100,
                                  colorText: Colors.red.shade900);
                              return;
                            }
                            controller.submitTransfer(
                                fromWarehouseId: fromWarehouseId!,
                                toWarehouseId: toWarehouseId!,
                                productSku: selectedProductSku!,
                                quantity: qtyController.text.trim(),
                                notes: notesController.text.trim());
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text('inv_process_transfer'.tr,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}