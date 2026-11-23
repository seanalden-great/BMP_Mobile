// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/role_permission_controller.dart';

// void logout() async {
//   // Hapus sesi lokal
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');

//   // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//   // ...

//   // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//   Get.offAllNamed(Routes.LOGIN);
// }

// class RoleMatrixView extends StatelessWidget {
//   const RoleMatrixView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RolePermissionController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: const Text('Pengaturan Hak Akses',
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
//         if (controller.isLoading.value && controller.roles.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               color: Colors.indigo.shade50,
//               child: Text(
//                 'Centang halaman yang boleh diakses oleh masing-masing jabatan. Halaman Profil selalu aktif untuk semua pengguna.',
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.indigo.shade900,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: controller.roles.length,
//                 itemBuilder: (context, index) {
//                   final role = controller.roles[index];

//                   return Card(
//                     elevation: 0,
//                     color: Colors.white,
//                     margin: const EdgeInsets.only(bottom: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: const BorderSide(color: Color(0xFFE2E8F0)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.shield_outlined,
//                                   size: 18, color: Color(0xFF2563EB)),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Jabatan: $role',
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1E293B)),
//                               ),
//                             ],
//                           ),
//                           const Divider(height: 20),
//                           // ...controller.menus.map((menu) {
//                           //   final isChecked =
//                           //       controller.hasReadAccess(role, menu);
//                           //   return CheckboxListTile(
//                           //     dense: true,
//                           //     contentPadding: EdgeInsets.zero,
//                           //     activeColor: const Color(0xFF2563EB),
//                           //     title: Text(menu,
//                           //         style: const TextStyle(
//                           //             fontWeight: FontWeight.w600,
//                           //             fontSize: 14)),
//                           //     value: isChecked,
//                           //     onChanged: (val) {
//                           //       controller.toggleMenuAccess(
//                           //           role, menu, val ?? false);
//                           //     },
//                           //   );
//                           // }),
                          
//                           ...controller.menus.map((menu) {
//                             return Obx(() {
//                               final isChecked =
//                                   controller.hasReadAccess(role, menu);
//                               return CheckboxListTile(
//                                 dense: true,
//                                 contentPadding: EdgeInsets.zero,
//                                 activeColor: const Color(0xFF2563EB),
//                                 title: Text(menu,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14)),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   controller.toggleMenuAccess(
//                                       role, menu, val ?? false);
//                                 },
//                               );
//                             });
//                           }),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: ElevatedButton.icon(
//                 onPressed: controller.isSaving.value
//                     ? null
//                     : controller.savePermissions,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 icon: controller.isSaving.value
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 2))
//                     : const Icon(Icons.save),
//                 label: const Text('Terapkan & Simpan Akses',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:bmp_mobile/services/language_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/role_permission_controller.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class RoleMatrixView extends StatelessWidget {
//   const RoleMatrixView({super.key});

//   String _translateMenu(String menu) {
//     switch (menu) {
//       case 'Dashboard':
//         return 'nav_dashboard'.tr;
//       case 'Inventori':
//         return 'nav_inventory'.tr;
//       case 'Produk':
//         return 'nav_products'.tr;
//       case 'Persetujuan':
//         return 'nav_approvals'.tr;
//       case 'Profil':
//         return 'nav_profile'.tr;
//       default:
//         return menu;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RolePermissionController());
//     final langService = Get.find<LanguageService>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: Text('rbac_title'.tr,
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
//       body: Obx(() {
//         if (controller.isLoading.value && controller.roles.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               color: Colors.indigo.shade50,
//               child: Text(
//                 'rbac_info_banner'.tr,
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.indigo.shade900,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: controller.roles.length,
//                 itemBuilder: (context, index) {
//                   final role = controller.roles[index];

//                   return Card(
//                     elevation: 0,
//                     color: Colors.white,
//                     margin: const EdgeInsets.only(bottom: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: const BorderSide(color: Color(0xFFE2E8F0)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.shield_outlined,
//                                   size: 18, color: Color(0xFF2563EB)),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'rbac_role_label'.trParams({'role': role}),
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1E293B)),
//                               ),
//                             ],
//                           ),
//                           const Divider(height: 20),
//                           ...controller.menus.map((menu) {
//                             return Obx(() {
//                               final isChecked =
//                                   controller.hasReadAccess(role, menu);
//                               return CheckboxListTile(
//                                 dense: true,
//                                 contentPadding: EdgeInsets.zero,
//                                 activeColor: const Color(0xFF2563EB),
//                                 title: Text(_translateMenu(menu),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14)),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   controller.toggleMenuAccess(
//                                       role, menu, val ?? false);
//                                 },
//                               );
//                             });
//                           }),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: ElevatedButton.icon(
//                 onPressed: controller.isSaving.value
//                     ? null
//                     : controller.savePermissions,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 icon: controller.isSaving.value
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 2))
//                     : const Icon(Icons.save),
//                 label: Text('rbac_save_btn'.tr,
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:bmp_mobile/services/language_service.dart';
import 'package:bmp_mobile/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/role_permission_controller.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class RoleMatrixView extends StatelessWidget {
  const RoleMatrixView({super.key});

  String _translateMenu(String menu) {
    switch (menu) {
      case 'Dashboard':
        return 'nav_dashboard'.tr;
      case 'Inventori':
        return 'nav_inventory'.tr;
      case 'Produk':
        return 'nav_products'.tr;
      case 'Persetujuan':
        return 'nav_approvals'.tr;
      case 'Profil':
        return 'nav_profile'.tr;
      default:
        return menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RolePermissionController());
    final langService = Get.find<LanguageService>();
    final themeService = Get.find<ThemeService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Palet warna dinamis
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('rbac_title'.tr,
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
      body: Obx(() {
        if (controller.isLoading.value && controller.roles.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: isDark
                  ? Colors.indigo.shade900.withOpacity(0.35)
                  : Colors.indigo.shade50,
              child: Text(
                'rbac_info_banner'.tr,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.indigo.shade200
                        : Colors.indigo.shade900,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.roles.length,
                itemBuilder: (context, index) {
                  final role = controller.roles[index];

                  return Card(
                    elevation: 0,
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shield_outlined,
                                  size: 18,
                                  color: isDark
                                      ? const Color(0xFF60A5FA)
                                      : const Color(0xFF2563EB)),
                              const SizedBox(width: 8),
                              Text(
                                'rbac_role_label'.trParams({'role': role}),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary),
                              ),
                            ],
                          ),
                          Divider(height: 20, color: borderColor),
                          ...controller.menus.map((menu) {
                            return Obx(() {
                              final isChecked =
                                  controller.hasReadAccess(role, menu);
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                activeColor: const Color(0xFF2563EB),
                                checkColor: Colors.white,
                                side: isDark
                                    ? const BorderSide(
                                        color: Color(0xFF94A3B8), width: 1.5)
                                    : null,
                                title: Text(_translateMenu(menu),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: textPrimary)),
                                value: isChecked,
                                onChanged: (val) {
                                  controller.toggleMenuAccess(
                                      role, menu, val ?? false);
                                },
                              );
                            });
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.savePermissions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text('rbac_save_btn'.tr,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      }),
    );
  }
}