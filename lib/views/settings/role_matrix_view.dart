import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/role_permission_controller.dart';

void logout() async {
  // Hapus sesi lokal
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

  // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
  // ...

  // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
  Get.offAllNamed(Routes.LOGIN);
}

class RoleMatrixView extends StatelessWidget {
  const RoleMatrixView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RolePermissionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Pengaturan Hak Akses',
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
        if (controller.isLoading.value && controller.roles.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: Colors.indigo.shade50,
              child: Text(
                'Centang halaman yang boleh diakses oleh masing-masing jabatan. Halaman Profil selalu aktif untuk semua pengguna.',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo.shade900,
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shield_outlined,
                                  size: 18, color: Color(0xFF2563EB)),
                              const SizedBox(width: 8),
                              Text(
                                'Jabatan: $role',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          // ...controller.menus.map((menu) {
                          //   final isChecked =
                          //       controller.hasReadAccess(role, menu);
                          //   return CheckboxListTile(
                          //     dense: true,
                          //     contentPadding: EdgeInsets.zero,
                          //     activeColor: const Color(0xFF2563EB),
                          //     title: Text(menu,
                          //         style: const TextStyle(
                          //             fontWeight: FontWeight.w600,
                          //             fontSize: 14)),
                          //     value: isChecked,
                          //     onChanged: (val) {
                          //       controller.toggleMenuAccess(
                          //           role, menu, val ?? false);
                          //     },
                          //   );
                          // }),
                          
                          ...controller.menus.map((menu) {
                            return Obx(() {
                              final isChecked =
                                  controller.hasReadAccess(role, menu);
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                activeColor: const Color(0xFF2563EB),
                                title: Text(menu,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
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
              color: Colors.white,
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
                label: const Text('Terapkan & Simpan Akses',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      }),
    );
  }
}
