import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/inventory_controller.dart';

void logout() async {
    // Hapus sesi lokal
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
    // ...

    // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
    Get.offAllNamed(Routes.LOGIN);
  }

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InventoryController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Data Pergerakan Stok & Gudang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
        if (controller.isLoading.value && controller.adjustments.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        if (controller.adjustments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.archive_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('Belum ada riwayat stok & mutasi.', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          color: const Color(0xFF2563EB),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 80),
            itemCount: controller.adjustments.length,
            itemBuilder: (context, index) {
              final adj = controller.adjustments[index];
              final isAdd = adj['type'] == 'Penambahan';
              final isTransfer = adj['reason'].toString().contains('[MUTASI');

              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade200),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isTransfer ? Colors.blue.shade50 : (isAdd ? Colors.green.shade50 : Colors.red.shade50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isTransfer ? Icons.repeat : (isAdd ? Icons.arrow_upward : Icons.arrow_downward),
                                  size: 14,
                                  color: isTransfer ? Colors.blue.shade700 : (isAdd ? Colors.green.shade700 : Colors.red.shade700),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isTransfer ? 'MUTASI STOK' : (isAdd ? 'TAMBAH' : 'KURANG'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isTransfer ? Colors.blue.shade700 : (isAdd ? Colors.green.shade700 : Colors.red.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(adj['date'] ?? '-', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '[${adj['product_sku']}] ${adj['product'] != null ? adj['product']['name'] : 'Produk Dihapus'}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lokasi: ${adj['warehouse'] != null ? adj['warehouse']['name'] : 'Gudang Utama'}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '"${adj['reason']}"',
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${adj['quantity']} ${adj['product'] != null ? adj['product']['unit'] : ''}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
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
      
      // Mengubah FAB untuk memunculkan Pilihan Aksi
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
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih Tindakan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.inventory, color: Colors.teal.shade600)),
              title: const Text('Stock Opname (Penyesuaian Fisik)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Cocokkan stok sistem dengan stok riil di gudang.'),
              onTap: () {
                Get.back();
                _showAdjustmentForm(context, controller);
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.repeat, color: Colors.blue.shade600)),
              title: const Text('Mutasi Antar Gudang', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Pindahkan barang dari satu cabang ke cabang lain.'),
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

  // --- FORM STOCK OPNAME (SEBELUMNYA) ---
  void _showAdjustmentForm(BuildContext context, InventoryController controller) {
    String? selectedWarehouseId, selectedProductSku, selectedType = 'Penambahan';
    final qtyController = TextEditingController();
    final reasonController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Form Penyesuaian Stok', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Lokasi Gudang', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: (val) => selectedWarehouseId = val,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pilih Produk', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                isExpanded: true,
                items: controller.products.map((p) => DropdownMenuItem<String>(value: p['sku'].toString(), child: Text('[${p['sku']}] ${p['name']}', style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: (val) => selectedProductSku = val,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(labelText: 'Tipe Mutasi', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      items: const [
                        DropdownMenuItem(value: 'Penambahan', child: Text('(+) Tambah', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'Pengurangan', child: Text('(-) Kurang', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (val) => selectedType = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Kuantitas', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: reasonController, maxLines: 2, decoration: InputDecoration(labelText: 'Alasan Penyesuaian', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value ? null : () {
                  if (selectedWarehouseId == null || selectedProductSku == null || qtyController.text.isEmpty) {
                    Get.snackbar('Validasi Gagal', 'Mohon lengkapi Gudang, Produk, dan Kuantitas', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
                    return;
                  }
                  controller.submitAdjustment(warehouseId: selectedWarehouseId!, productSku: selectedProductSku!, type: selectedType!, quantity: qtyController.text.trim(), reason: reasonController.text.trim().isEmpty ? 'Penyesuaian Fisik Lapangan' : reasonController.text.trim());
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan & Jurnal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- FORM BARU: MUTASI ANTAR GUDANG (TRANSFER) ---
  void _showTransferForm(BuildContext context, InventoryController controller) {
    String? fromWarehouseId, toWarehouseId, selectedProductSku;
    final qtyController = TextEditingController();
    final notesController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.repeat, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  const Text('Transfer Antar Gudang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gudang Asal (Keluar)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), fillColor: Colors.red.shade50, filled: true),
                items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: (val) => fromWarehouseId = val,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gudang Tujuan (Masuk)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), fillColor: Colors.green.shade50, filled: true),
                items: controller.warehouses.map((wh) => DropdownMenuItem<String>(value: wh['id'].toString(), child: Text('[${wh['code']}] ${wh['name']}', style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: (val) => toWarehouseId = val,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Pilih Produk', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      isExpanded: true,
                      items: controller.products.map((p) => DropdownMenuItem<String>(value: p['sku'].toString(), child: Text('[${p['sku']}] ${p['name']}', style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (val) => selectedProductSku = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Jumlah', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: notesController, maxLines: 2, decoration: InputDecoration(labelText: 'Catatan Pengiriman (Nopol, Supir, dsb)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value ? null : () {
                  if (fromWarehouseId == null || toWarehouseId == null || selectedProductSku == null || qtyController.text.isEmpty) {
                    Get.snackbar('Validasi Gagal', 'Lengkapi seluruh data wajib!', backgroundColor: Colors.amber.shade100, colorText: Colors.amber.shade900);
                    return;
                  }
                  if (fromWarehouseId == toWarehouseId) {
                    Get.snackbar('Kesalahan', 'Gudang Asal dan Tujuan tidak boleh sama.', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
                    return;
                  }
                  controller.submitTransfer(fromWarehouseId: fromWarehouseId!, toWarehouseId: toWarehouseId!, productSku: selectedProductSku!, quantity: qtyController.text.trim(), notes: notesController.text.trim());
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Proses Pindahkan Stok', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}