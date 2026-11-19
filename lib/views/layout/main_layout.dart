// import 'package:bmp_mobile/views/approval/approval_view.dart';
// import 'package:bmp_mobile/views/dashboard/dashboard_view.dart';
// import 'package:bmp_mobile/views/products/product_view.dart';
// import 'package:bmp_mobile/views/profile/profile_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../routes/app_pages.dart';
// import '../inventory/inventory_view.dart'; // Akan dibuat setelah ini

// class MainLayoutController extends GetxController {
//   var selectedIndex = 0.obs;

//   void changePage(int index) {
//     selectedIndex.value = index;
//   }

//   void logout() async {
//     // Hapus sesi lokal
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
    
//     // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//     // ...

//     // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//     Get.offAllNamed(Routes.LOGIN);
//   }
// }

// class MainLayout extends StatelessWidget {
//   const MainLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MainLayoutController());

//     // Daftar Modul Utama Mobile
//     final List<Widget> pages = [
//       const DashboardView(),
//       const InventoryView(), // Ini adalah halaman Inventory yang baru
//       const ProductView(),
//       const ApprovalView(),
//       const ProfileView(), // INI ADALAH MODUL PROFIL YANG BARU
//     ];

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('BMP Mobile'),
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.logout),
//       //       tooltip: 'Keluar',
//       //       onPressed: () {
//       //         Get.defaultDialog(
//       //           title: "Konfirmasi Keluar",
//       //           middleText: "Anda yakin ingin keluar dari sistem?",
//       //           textCancel: "Batal",
//       //           textConfirm: "Ya, Keluar",
//       //           confirmTextColor: Colors.white,
//       //           buttonColor: Colors.red,
//       //           onConfirm: () => controller.logout(),
//       //         );
//       //       },
//       //     )
//       //   ],
//       // ),
//       body: Obx(() => pages[controller.selectedIndex.value]),
//       bottomNavigationBar: Obx(
//         () => NavigationBar(
//           selectedIndex: controller.selectedIndex.value,
//           onDestinationSelected: controller.changePage,
//           backgroundColor: Colors.white,
//           indicatorColor: const Color(0xFFDBEAFE),
//           destinations: const [
//             NavigationDestination(
//               icon: Icon(Icons.dashboard_outlined),
//               selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)),
//               label: 'Dasbor',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.inventory_2_outlined),
//               selectedIcon: Icon(Icons.inventory_2, color: Color(0xFF2563EB)),
//               label: 'Inventori',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.shopping_bag_outlined),
//               selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF2563EB)),
//               label: 'Produk',
//             ),
//             NavigationDestination(
//               icon: Badge(child: Icon(Icons.fact_check_outlined)),
//               selectedIcon: Badge(child: Icon(Icons.fact_check, color: Color(0xFF2563EB))),
//               label: 'Persetujuan',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.person_outline),
//               selectedIcon: Icon(Icons.person, color: Color(0xFF2563EB)),
//               label: 'Profil',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/controllers/role_permission_controller.dart';
import 'package:bmp_mobile/views/approval/approval_view.dart';
import 'package:bmp_mobile/views/dashboard/dashboard_view.dart';
import 'package:bmp_mobile/views/products/product_view.dart';
import 'package:bmp_mobile/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import '../inventory/inventory_view.dart';

class MainLayoutController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Get.delete<RolePermissionController>();
    Get.offAllNamed(Routes.LOGIN);
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());
    final permController = Get.put(RolePermissionController());

    return Obx(() {
      if (permController.isLoading.value && permController.permissions.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
        );
      }

      // Susun halaman & tab secara dinamis berdasarkan hak akses user
      final List<Widget> allowedPages = [];
      final List<NavigationDestination> allowedDestinations = [];

      if (permController.canCurrentUserAccess('Dashboard')) {
        allowedPages.add(const DashboardView());
        allowedDestinations.add(const NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)),
          label: 'Dasbor',
        ));
      }

      if (permController.canCurrentUserAccess('Inventori')) {
        allowedPages.add(const InventoryView());
        allowedDestinations.add(const NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2, color: Color(0xFF2563EB)),
          label: 'Inventori',
        ));
      }

      if (permController.canCurrentUserAccess('Produk')) {
        allowedPages.add(const ProductView());
        allowedDestinations.add(const NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF2563EB)),
          label: 'Produk',
        ));
      }

      if (permController.canCurrentUserAccess('Persetujuan')) {
        allowedPages.add(const ApprovalView());
        allowedDestinations.add(const NavigationDestination(
          icon: Badge(child: Icon(Icons.fact_check_outlined)),
          selectedIcon: Badge(child: Icon(Icons.fact_check, color: Color(0xFF2563EB))),
          label: 'Persetujuan',
        ));
      }

      // Profil selalu ada untuk semua role
      allowedPages.add(const ProfileView());
      allowedDestinations.add(const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person, color: Color(0xFF2563EB)),
        label: 'Profil',
      ));

      // Pengaman agar selectedIndex tidak out-of-range saat hak akses berubah
      final safeIndex = controller.selectedIndex.value >= allowedPages.length
          ? 0
          : controller.selectedIndex.value;

      return Scaffold(
        body: allowedPages[safeIndex],
        // NavigationBar Flutter butuh minimal 2 destinations
        bottomNavigationBar: allowedDestinations.length >= 2
            ? NavigationBar(
                selectedIndex: safeIndex,
                onDestinationSelected: controller.changePage,
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFFDBEAFE),
                destinations: allowedDestinations,
              )
            : null,
      );
    });
  }
}