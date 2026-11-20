// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/product_controller.dart';
// import 'product_detail_view.dart';

// void logout() async {
//     // Hapus sesi lokal
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
    
//     // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//     // ...

//     // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//     Get.offAllNamed(Routes.LOGIN);
//   }

// class ProductView extends StatelessWidget {
//   const ProductView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProductController());
//     final searchTextController = TextEditingController();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text('Daftar Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
//           // Search Bar
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
//             child: Obx(() => TextField(
//               controller: searchTextController,
//               onChanged: controller.onSearchChanged,
//               decoration: InputDecoration(
//                 hintText: 'Cari nama produk, SKU, atau kategori...',
//                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 suffixIcon: controller.searchQuery.value.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: () {
//                           searchTextController.clear();
//                           controller.onSearchChanged('');
//                         },
//                       )
//                     : null,
//                 filled: true,
//                 fillColor: const Color(0xFFF1F5F9),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             )),
//           ),

//           // Daftar Produk
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value && controller.products.isEmpty) {
//                 return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//               }

//               if (controller.products.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
//                       const SizedBox(height: 12),
//                       Text(
//                         controller.searchQuery.value.isNotEmpty
//                             ? 'Produk "${controller.searchQuery.value}" tidak ditemukan.'
//                             : 'Belum ada data Master Produk.',
//                         style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: () => controller.fetchProducts(),
//                 color: const Color(0xFF2563EB),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
//                   itemCount: controller.products.length,
//                   itemBuilder: (context, index) {
//                     final p = controller.products[index];
//                     final totalStock = int.tryParse(p['total_stock']?.toString() ?? '0') ?? 0;

//                     return Card(
//                       elevation: 0,
//                       color: Colors.white,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.grey.shade200),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(12),
//                         onTap: () {
//                           Get.to(() => ProductDetailView(productId: p['id']));
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(14),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue.shade50,
//                                           borderRadius: BorderRadius.circular(6),
//                                         ),
//                                         child: Text(
//                                           p['sku'] ?? '-',
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             fontWeight: FontWeight.bold,
//                                             fontFamily: 'monospace',
//                                             color: Colors.blue.shade700,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey.shade100, // Jika error warna, ganti Colors.grey.shade100
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Text(
//                                           p['category'] ?? '-',
//                                           style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   PopupMenuButton<String>(
//                                     padding: EdgeInsets.zero,
//                                     icon: Icon(Icons.more_vert, size: 20, color: Colors.grey.shade600),
//                                     onSelected: (val) {
//                                       if (val == 'detail') {
//                                         Get.to(() => ProductDetailView(productId: p['id']));
//                                       } else if (val == 'edit') {
//                                         _showProductForm(context, controller, product: p);
//                                       } else if (val == 'delete') {
//                                         _confirmDelete(controller, p['id'], p['name']);
//                                       }
//                                     },
//                                     itemBuilder: (context) => [
//                                       const PopupMenuItem(value: 'detail', child: Text('Kartu Stok & Detail')),
//                                       const PopupMenuItem(value: 'edit', child: Text('Edit Produk')),
//                                       const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 p['name'] ?? '-',
//                                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
//                               ),
//                               const Divider(height: 20),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('HPP Berjalan', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//                                       Text(
//                                         controller.formatRupiah(p['hpp']),
//                                         style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange.shade700),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Harga Jual', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//                                       Text(
//                                         controller.formatRupiah(p['sell_price']),
//                                         style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text('Total Stok', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//                                       Text(
//                                         '$totalStock ${p['unit'] ?? ''}',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w900,
//                                           color: totalStock <= 0 ? Colors.red.shade600 : Colors.green.shade600, // Ganti Colors.green.shade600 jika emerald tidak ada
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
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
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showProductForm(context, controller),
//         backgroundColor: const Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         icon: const Icon(Icons.add),
//         label: const Text('Tambah Produk', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }

//   void _confirmDelete(ProductController controller, int id, String name) {
//     Get.defaultDialog(
//       title: 'Hapus Produk?',
//       middleText: 'Yakin ingin menghapus "$name" secara permanen? Tindakan ini tidak dapat dibatalkan.',
//       textConfirm: 'Ya, Hapus',
//       textCancel: 'Batal',
//       confirmTextColor: Colors.white,
//       buttonColor: Colors.red,
//       onConfirm: () {
//         Get.back();
//         controller.deleteProduct(id);
//       },
//     );
//   }

//   void _showProductForm(BuildContext context, ProductController controller, {Map<String, dynamic>? product}) {
//     final isEdit = product != null;
//     final skuCtrl = TextEditingController(text: isEdit ? product['sku'] : '');
//     final nameCtrl = TextEditingController(text: isEdit ? product['name'] : '');
//     final unitCtrl = TextEditingController(text: isEdit ? (product['unit'] ?? 'Pcs') : 'Pcs');
//     String? selectedCategory = isEdit ? product['category'] : (controller.categories.isNotEmpty ? controller.categories.first : null);

//     Get.bottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           left: 20, right: 20, top: 20,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 isEdit ? 'Edit Master Produk' : 'Tambah Produk Baru',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: skuCtrl,
//                 textCapitalization: TextCapitalization.characters,
//                 decoration: InputDecoration(
//                   labelText: 'SKU (Kode Barang)',
//                   hintText: 'Misal: BRG-001',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: nameCtrl,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Produk',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: DropdownButtonFormField<String>(
//                       value: controller.categories.contains(selectedCategory) ? selectedCategory : null,
//                       decoration: InputDecoration(
//                         labelText: 'Kategori',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       items: controller.categories.map((cat) {
//                         return DropdownMenuItem<String>(value: cat, child: Text(cat));
//                       }).toList(),
//                       onChanged: (val) => selectedCategory = val,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 2,
//                     child: TextField(
//                       controller: unitCtrl,
//                       decoration: InputDecoration(
//                         labelText: 'Satuan',
//                         hintText: 'Pcs/Kg',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   'Info ERP: Stok Awal, HPP, Harga Jual, dan Harga Beli diatur otomatis melalui modul Pembelian, Penjualan, dan Penyesuaian.',
//                   style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Obx(() => ElevatedButton(
//                 onPressed: controller.isSubmitting.value
//                     ? null
//                     : () {
//                         if (skuCtrl.text.trim().isEmpty || nameCtrl.text.trim().isEmpty || selectedCategory == null) {
//                           Get.snackbar('Validasi', 'SKU, Nama Produk, dan Kategori wajib diisi!',
//                               backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
//                           return;
//                         }
//                         controller.saveProduct(
//                           id: isEdit ? product['id'] : null,
//                           sku: skuCtrl.text,
//                           name: nameCtrl.text,
//                           category: selectedCategory!,
//                           unit: unitCtrl.text,
//                         );
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: controller.isSubmitting.value
//                     ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                     : const Text('Simpan Master', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/product_controller.dart';
import '../../models/product.dart';
import 'product_detail_view.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final searchTextController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Daftar Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Obx(() => TextField(
              controller: searchTextController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama produk, SKU, atau kategori...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          searchTextController.clear();
                          controller.onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
          ),

          // Daftar Produk
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              if (controller.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'Produk "${controller.searchQuery.value}" tidak ditemukan.'
                            : 'Belum ada data Master Produk.',
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchProducts(),
                color: const Color(0xFF2563EB),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final p = controller.products[index];

                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: p.isPendingSync
                              ? Colors.amber.shade400
                              : Colors.grey.shade200,),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        // onTap: () {
                        //   Get.to(() => ProductDetailView(productId: p.id));
                        // },
                        onTap: () {
                          if (p.id <= 0) {
                            Get.snackbar(
                              'Menunggu Sinkronisasi',
                              'Kartu stok akan tersedia setelah produk ini tersinkron ke server.',
                              backgroundColor: Colors.amber.shade100,
                              colorText: Colors.amber.shade900,
                            );
                            return;
                          }
                          Get.to(() => ProductDetailView(productId: p.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Container(
                              //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              //           decoration: BoxDecoration(
                              //             color: Colors.blue.shade50,
                              //             borderRadius: BorderRadius.circular(6),
                              //           ),
                              //           child: Text(
                              //             p.sku,
                              //             style: TextStyle(
                              //               fontSize: 11,
                              //               fontWeight: FontWeight.bold,
                              //               fontFamily: 'monospace',
                              //               color: Colors.blue.shade700,
                              //             ),
                              //           ),
                              //         ),
                              //         const SizedBox(width: 8),
                              //         Container(
                              //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              //           decoration: BoxDecoration(
                              //             color: Colors.grey.shade100,
                              //             borderRadius: BorderRadius.circular(12),
                              //           ),
                              //           child: Text(
                              //             p.category,
                              //             style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     PopupMenuButton<String>(
                              //       padding: EdgeInsets.zero,
                              //       icon: Icon(Icons.more_vert, size: 20, color: Colors.grey.shade600),
                              //       onSelected: (val) {
                              //         if (val == 'detail') {
                              //           Get.to(() => ProductDetailView(productId: p.id));
                              //         } else if (val == 'edit') {
                              //           _showProductForm(context, controller, product: p);
                              //         } else if (val == 'delete') {
                              //           _confirmDelete(controller, p.id, p.name);
                              //         }
                              //       },
                              //       itemBuilder: (context) => [
                              //         const PopupMenuItem(value: 'detail', child: Text('Kartu Stok & Detail')),
                              //         const PopupMenuItem(value: 'edit', child: Text('Edit Produk')),
                              //         const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                              //       ],
                              //     ),
                              //   ],
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            p.sku,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            p.category,
                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        if (p.isPendingSync)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Menunggu Sync',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber.shade900,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (p.id > 0)
                                    PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.more_vert, size: 20, color: Colors.grey.shade600),
                                      onSelected: (val) {
                                        if (val == 'detail') {
                                          Get.to(() => ProductDetailView(productId: p.id));
                                        } else if (val == 'edit') {
                                          _showProductForm(context, controller, product: p);
                                        } else if (val == 'delete') {
                                          _confirmDelete(controller, p.id, p.name);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(value: 'detail', child: Text('Kartu Stok & Detail')),
                                        const PopupMenuItem(value: 'edit', child: Text('Edit Produk')),
                                        const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('HPP Berjalan', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                      Text(
                                        controller.formatRupiah(p.hpp),
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange.shade700),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Harga Jual', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                      Text(
                                        controller.formatRupiah(p.sellPrice),
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Total Stok', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                      Text(
                                        '${p.totalStock} ${p.unit}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: p.totalStock <= 0 ? Colors.red.shade600 : Colors.green.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(context, controller),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _confirmDelete(ProductController controller, int id, String name) {
    Get.defaultDialog(
      title: 'Hapus Produk?',
      middleText: 'Yakin ingin menghapus "$name" secara permanen? Tindakan ini tidak dapat dibatalkan.',
      textConfirm: 'Ya, Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteProduct(id);
      },
    );
  }

  void _showProductForm(BuildContext context, ProductController controller, {Product? product}) {
    final isEdit = product != null;
    final skuCtrl = TextEditingController(text: isEdit ? product.sku : '');
    final nameCtrl = TextEditingController(text: isEdit ? product.name : '');
    final unitCtrl = TextEditingController(text: isEdit ? product.unit : 'Pcs');
    String? selectedCategory = isEdit
        ? product.category
        : (controller.categories.isNotEmpty ? controller.categories.first : null);

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Edit Master Produk' : 'Tambah Produk Baru',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skuCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'SKU (Kode Barang)',
                  hintText: 'Misal: BRG-001',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: controller.categories.contains(selectedCategory) ? selectedCategory : null,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: controller.categories.map((cat) {
                        return DropdownMenuItem<String>(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) => selectedCategory = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: unitCtrl,
                      decoration: InputDecoration(
                        labelText: 'Satuan',
                        hintText: 'Pcs/Kg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Info ERP: Stok Awal, HPP, Harga Jual, dan Harga Beli diatur otomatis melalui modul Pembelian, Penjualan, dan Penyesuaian.',
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () {
                        if (skuCtrl.text.trim().isEmpty || nameCtrl.text.trim().isEmpty || selectedCategory == null) {
                          Get.snackbar('Validasi', 'SKU, Nama Produk, dan Kategori wajib diisi!',
                              backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
                          return;
                        }
                        controller.saveProduct(
                          id: isEdit ? product.id : null,
                          sku: skuCtrl.text,
                          name: nameCtrl.text,
                          category: selectedCategory!,
                          unit: unitCtrl.text,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan Master', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}