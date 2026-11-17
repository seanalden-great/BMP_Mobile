import 'package:bmp_mobile/views/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import '../inventory/inventory_view.dart'; // Akan dibuat setelah ini

class MainLayoutController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void logout() async {
    // Hapus sesi lokal
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
    // ...

    // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
    Get.offAllNamed(Routes.LOGIN);
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());

    // Daftar Modul Utama Mobile
    final List<Widget> pages = [
      const DashboardView(),
      const InventoryView(), // Ini adalah halaman Inventory yang baru
      const Center(child: Text("Approval Center\n(Sedang Dikembangkan)", textAlign: TextAlign.center)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMP Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi Keluar",
                middleText: "Anda yakin ingin keluar dari sistem?",
                textCancel: "Batal",
                textConfirm: "Ya, Keluar",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => controller.logout(),
              );
            },
          )
        ],
      ),
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changePage,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDBEAFE),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)),
              label: 'Dasbor',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2, color: Color(0xFF2563EB)),
              label: 'Inventori',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.fact_check_outlined)),
              selectedIcon: Badge(child: Icon(Icons.fact_check, color: Color(0xFF2563EB))),
              label: 'Persetujuan',
            ),
          ],
        ),
      ),
    );
  }
}