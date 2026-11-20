// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/product_controller.dart';

// void logout() async {
//   // Hapus sesi lokal
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');

//   // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//   // ...

//   // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ProductDetailView extends StatefulWidget {
//   final int productId;
//   const ProductDetailView({super.key, required this.productId});

//   @override
//   State<ProductDetailView> createState() => _ProductDetailViewState();
// }

// class _ProductDetailViewState extends State<ProductDetailView> {
//   final controller = Get.find<ProductController>();

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchProductDetail(widget.productId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         appBar: AppBar(
//           title: const Text('Detail Produk',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           backgroundColor: const Color(0xFF2563EB),
//           foregroundColor: const Color(0xFF1E293B),
//           elevation: 0,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout, color: Colors.white),
//               tooltip: 'Keluar',
//               onPressed: () {
//                 Get.defaultDialog(
//                   title: "Konfirmasi Keluar",
//                   middleText: "Anda yakin ingin keluar dari sistem?",
//                   textCancel: "Batal",
//                   textConfirm: "Ya, Keluar",
//                   confirmTextColor: Colors.white,
//                   buttonColor: Colors.red,
//                   onConfirm: () => logout(),
//                 );
//               },
//             )
//           ],
//         ),
//         body: Obx(() {
//           if (controller.isDetailLoading.value ||
//               controller.productDetail.value == null) {
//             return const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//           }

//           final detail = controller.productDetail.value!;
//           final product = detail['product'];
//           final stocks = detail['stocks'] as List;
//           final sales = detail['sale_history'] as List;
//           final purchases = detail['purchase_history'] as List;
//           final adjustments = detail['adjustments'] as List;
//           final totalStock =
//               int.tryParse(product['total_stock']?.toString() ?? '0') ?? 0;

//           return NestedScrollView(
//             headerSliverBuilder: (context, _) => [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Identitas Produk
//                       Text(product['name'] ?? '-',
//                           style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                               color: Color(0xFF1E293B))),
//                       const SizedBox(height: 4),
//                       Text(
//                           'SKU: ${product['sku']}  |  Kategori: ${product['category'] ?? '-'}',
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.grey.shade600)),
//                       const SizedBox(height: 16),

//                       // 4 Kartu Metrik
//                       GridView.count(
//                         crossAxisCount: 2,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 2.1,
//                         children: [
//                           _metricCard(
//                               'Total Stok',
//                               '$totalStock ${product['unit'] ?? ''}',
//                               totalStock <= 0 ? Colors.red : Colors.green),
//                           _metricCard(
//                               'HPP (Avg)',
//                               controller.formatRupiah(product['hpp']),
//                               Colors.orange.shade700),
//                           _metricCard(
//                               'Harga Jual',
//                               controller.formatRupiah(product['sell_price']),
//                               Colors.indigo.shade700),
//                           _metricCard(
//                               'Harga Beli Akhir',
//                               controller.formatRupiah(product['buy_price']),
//                               const Color(0xFF334155)),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Peta Lokasi Gudang
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('SEBARAN STOK GUDANG',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey)),
//                             const SizedBox(height: 8),
//                             if (stocks.isEmpty)
//                               const Text(
//                                   'Belum ada alokasi stok di gudang manapun.',
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.grey))
//                             else
//                               ...stocks.map((st) => Padding(
//                                     padding:
//                                         const EdgeInsets.symmetric(vertical: 4),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                             st['warehouse']?['name'] ??
//                                                 'Gudang Utama',
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w600)),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8, vertical: 2),
//                                           decoration: BoxDecoration(
//                                               color: Colors.green.shade50,
//                                               borderRadius:
//                                                   BorderRadius.circular(6)),
//                                           child: Text(
//                                               '${st['quantity']} ${product['unit'] ?? ''}',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.green.shade700,
//                                                   fontSize: 12)),
//                                         ),
//                                       ],
//                                     ),
//                                   )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _SliverTabBarDelegate(
//                   const TabBar(
//                     labelColor: Color(0xFF2563EB),
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Color(0xFF2563EB),
//                     tabs: [
//                       Tab(text: 'Penjualan'),
//                       Tab(text: 'Pembelian'),
//                       Tab(text: 'Opname'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//             body: TabBarView(
//               children: [
//                 // Tab 1: Penjualan
//                 _buildHistoryList(
//                   items: sales,
//                   emptyText: 'Belum ada riwayat penjualan.',
//                   itemBuilder: (item) => ListTile(
//                     title: Text(item['sale']?['contact']?['name'] ?? '-',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 14)),
//                     subtitle: Text(
//                         '${item['sale']?['date'] ?? '-'} • ${item['sale']?['reference_no'] ?? '-'}',
//                         style: const TextStyle(fontSize: 12)),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text('-${item['quantity']}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 15,
//                                 color: Colors.indigo)),
//                         Text(controller.formatRupiah(item['price']),
//                             style: const TextStyle(
//                                 fontSize: 11, color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Tab 2: Pembelian
//                 _buildHistoryList(
//                   items: purchases,
//                   emptyText: 'Belum ada riwayat pembelian.',
//                   itemBuilder: (item) => ListTile(
//                     title: Text(item['purchase']?['contact']?['name'] ?? '-',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 14)),
//                     subtitle: Text(
//                         '${item['purchase']?['date'] ?? '-'} • ${item['purchase']?['reference_no'] ?? '-'}',
//                         style: const TextStyle(fontSize: 12)),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text('+${item['quantity']}',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 15,
//                                 color: Colors.orange.shade700)),
//                         Text(controller.formatRupiah(item['price']),
//                             style: const TextStyle(
//                                 fontSize: 11, color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Tab 3: Stock Opname
//                 _buildHistoryList(
//                   items: adjustments,
//                   emptyText: 'Belum ada riwayat penyesuaian stok.',
//                   itemBuilder: (item) {
//                     final isAdd = item['type'] == 'Penambahan';
//                     return ListTile(
//                       title: Text(item['warehouse']?['name'] ?? '-',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14)),
//                       subtitle: Text(
//                           '${item['date'] ?? '-'} • ${item['reason'] ?? '-'}',
//                           style: const TextStyle(fontSize: 12),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis),
//                       trailing: Text(
//                         '${isAdd ? '+' : '-'}${item['quantity']}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w900,
//                             fontSize: 16,
//                             color: isAdd ? Colors.teal : Colors.red),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _metricCard(String title, String value, Color valueColor) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(title,
//               style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey.shade500,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(value,
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w900,
//                     color: valueColor)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryList({
//     required List items,
//     required String emptyText,
//     required Widget Function(dynamic item) itemBuilder,
//   }) {
//     if (items.isEmpty) {
//       return Center(
//           child: Text(emptyText, style: const TextStyle(color: Colors.grey)));
//     }
//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: items.length,
//       separatorBuilder: (_, __) => const Divider(height: 1),
//       itemBuilder: (context, index) => Container(
//         color: Colors.white,
//         child: itemBuilder(items[index]),
//       ),
//     );
//   }
// }

// class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//   _SliverTabBarDelegate(this.tabBar);

//   @override
//   double get minExtent => tabBar.preferredSize.height;
//   @override
//   double get maxExtent => tabBar.preferredSize.height;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(color: Colors.white, child: tabBar);
//   }

//   @override
//   bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/product_controller.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class ProductDetailView extends StatefulWidget {
  final int productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    controller.fetchProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Detail Produk',
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
        body: Obx(() {
          // final detail = controller.productDetail.value;
          // if (controller.isDetailLoading.value || detail == null) {
          //   return const Center(
          //       child: CircularProgressIndicator(color: Color(0xFF2563EB)));
          // }

          // final product = detail.product;

          if (controller.isDetailLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2563EB)));
          }

          final detail = controller.productDetail.value;
          if (detail == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Detail kartu stok belum tersedia offline.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hubungkan ke internet untuk memuat riwayat transaksi produk ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchProductDetail(widget.productId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = detail.product;

          return NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Identitas Produk
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      Text(
                          'SKU: ${product.sku}  |  Kategori: ${product.category}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                      const SizedBox(height: 16),

                      // 4 Kartu Metrik
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.1,
                        children: [
                          _metricCard(
                              'Total Stok',
                              '${product.totalStock} ${product.unit}',
                              product.totalStock <= 0 ? Colors.red : Colors.green),
                          _metricCard(
                              'HPP (Avg)',
                              controller.formatRupiah(product.hpp),
                              Colors.orange.shade700),
                          _metricCard(
                              'Harga Jual',
                              controller.formatRupiah(product.sellPrice),
                              Colors.indigo.shade700),
                          _metricCard(
                              'Harga Beli Akhir',
                              controller.formatRupiah(product.buyPrice),
                              const Color(0xFF334155)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Peta Lokasi Gudang
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SEBARAN STOK GUDANG',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            const SizedBox(height: 8),
                            if (detail.stocks.isEmpty)
                              const Text(
                                  'Belum ada alokasi stok di gudang manapun.',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey))
                            else
                              ...detail.stocks.map((st) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(st.warehouseName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Text(
                                              '${st.quantity} ${product.unit}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade700,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  const TabBar(
                    labelColor: Color(0xFF2563EB),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF2563EB),
                    tabs: [
                      Tab(text: 'Penjualan'),
                      Tab(text: 'Pembelian'),
                      Tab(text: 'Opname'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                // Tab 1: Penjualan
                _buildHistoryList(
                  items: detail.saleHistory,
                  emptyText: 'Belum ada riwayat penjualan.',
                  itemBuilder: (item) => ListTile(
                    title: Text(item.contactName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${item.date} • ${item.referenceNo}',
                        style: const TextStyle(fontSize: 12)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('-${item.quantity}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: Colors.indigo)),
                        Text(controller.formatRupiah(item.price),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                // Tab 2: Pembelian
                _buildHistoryList(
                  items: detail.purchaseHistory,
                  emptyText: 'Belum ada riwayat pembelian.',
                  itemBuilder: (item) => ListTile(
                    title: Text(item.contactName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${item.date} • ${item.referenceNo}',
                        style: const TextStyle(fontSize: 12)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('+${item.quantity}',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: Colors.orange.shade700)),
                        Text(controller.formatRupiah(item.price),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                // Tab 3: Stock Opname
                _buildHistoryList(
                  items: detail.adjustments,
                  emptyText: 'Belum ada riwayat penyesuaian stok.',
                  itemBuilder: (item) => ListTile(
                    title: Text(item.warehouseName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${item.date} • ${item.reason}',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    trailing: Text(
                      '${item.isAddition ? '+' : '-'}${item.quantity}',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: item.isAddition ? Colors.teal : Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _metricCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: valueColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList<T>({
    required List<T> items,
    required String emptyText,
    required Widget Function(T item) itemBuilder,
  }) {
    if (items.isEmpty) {
      return Center(
          child: Text(emptyText, style: const TextStyle(color: Colors.grey)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => Container(
        color: Colors.white,
        child: itemBuilder(items[index]),
      ),
    );
  }

  // Widget _buildHistoryList<T extends Object>({
  //   required List<T> items,
  //   required String emptyText,
  //   required Widget Function(T item) itemBuilder,
  // }) {
  //   if (items.isEmpty) {
  //     return Center(
  //         child: Text(emptyText, style: const TextStyle(color: Colors.grey)));
  //   }
  //   return ListView.separated(
  //     padding: const EdgeInsets.all(12),
  //     itemCount: items.length,
  //     separatorBuilder: (_, __) => const Divider(height: 1),
  //     itemBuilder: (context, index) => Container(
  //       color: Colors.white,
  //       child: itemBuilder(items[index]),
  //     ),
  //   );
  // }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}