// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/profile_controller.dart';
// import '../settings/role_matrix_view.dart';

// void logout() async {
//   // Hapus sesi lokal
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');

//   // Jangan lupa panggil API Logout ke server (Opsional tapi disarankan)
//   // ...

//   // Lempar kembali ke halaman Login secara permanen (hapus histori navigasi)
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9), // Slate-100
//       appBar: AppBar(
//         title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
//         if (controller.isLoading.value && controller.userProfile.isEmpty) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         final user = controller.userProfile;

//         return RefreshIndicator(
//           onRefresh: controller.fetchProfile,
//           color: const Color(0xFF2563EB),
//           child: ListView(
//             padding: const EdgeInsets.all(20.0),
//             children: [
//               // Header Profil Singkat
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 36,
//                     backgroundColor: const Color(0xFF2563EB),
//                     child: Text(
//                       (user['name'] ?? 'U').toString().substring(0, 1).toUpperCase(),
//                       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(user['full_name'] ?? user['name'] ?? 'Pengguna', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
//                         Text('${user['role'] ?? 'Staff'} / @${user['username']}', style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),

//               // Tombol Khusus Admin / Direktur / Developer ke Matriks Hak Akses
//               if (['Admin', 'Direktur', 'Developer'].contains(user['role'])) ...[
//                 InkWell(
//                   onTap: () => Get.to(() => const RoleMatrixView()),
//                   borderRadius: BorderRadius.circular(12),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.indigo.shade200),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.indigo.shade600,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
//                         ),
//                         const SizedBox(width: 12),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Matriks Hak Akses (RBAC)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14)),
//                               Text('Atur halaman yang dapat diakses tiap jabatan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                             ],
//                           ),
//                         ),
//                         const Icon(Icons.chevron_right, color: Color(0xFF475569)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],

//               const Text('Informasi Personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
//               _buildTextField('Nama Lengkap', controller.fullNameController),
//               const SizedBox(height: 12),
//               _buildTextField('Nama Panggilan (Wajib)', controller.nameController),
//               const SizedBox(height: 12),
//               _buildTextField('Nomor Telepon', controller.phoneController, isNumber: true),
//               const SizedBox(height: 12),
//               _buildTextField('Alamat Email', controller.emailController, isEmail: true),
              
//               const SizedBox(height: 24),
//               const Text('Keamanan & Kredensial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
//               _buildTextField('Username', controller.usernameController),
//               const SizedBox(height: 12),
//               _buildTextField('Kata Sandi Baru (Opsional)', controller.passwordController, isPassword: true),
//               const SizedBox(height: 12),
//               _buildTextField('Ulangi Sandi Baru', controller.passwordConfirmController, isPassword: true),

//               const SizedBox(height: 24),
//               const Text('Preferensi Sistem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
              
//               // Toggle Email
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.mail_outline, color: Color(0xFF2563EB)),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Notifikasi Email', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                           Text('Terima pemberitahuan ERP di inbox.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                         ],
//                       ),
//                     ),
//                     Switch(
//                       value: controller.emailNotifications.value,
//                       onChanged: (val) => controller.emailNotifications.value = val,
//                       activeColor: const Color(0xFF2563EB),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   onPressed: controller.isSaving.value ? null : controller.updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2563EB),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   icon: controller.isSaving.value 
//                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
//                       : const Icon(Icons.save),
//                   label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 ),
//               ),

//               const SizedBox(height: 32),
//               const Text('Aktivitas Login Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
              
//               // Tabel Log / Riwayat Aktivitas Login
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: controller.loginLogs.isEmpty 
//                     ? const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('Belum ada data login terekam.', style: TextStyle(color: Colors.grey))))
//                     : Column(
//                         children: controller.loginLogs.map((log) {
//                           bool isMobile = log['user_agent'].toString().toLowerCase().contains('mobile');
//                           return ListTile(
//                             leading: Icon(isMobile ? Icons.smartphone : Icons.computer, color: const Color(0xFF64748B)),
//                             title: Text(log['ip_address'] ?? 'Unknown IP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
//                             subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(log['created_at'])), style: const TextStyle(fontSize: 11)),
//                             trailing: const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
//                           );
//                         }).toList(),
//                       ),
//               ),
//               const SizedBox(height: 12),
//               const Text('Jika Anda melihat Alamat IP asing, segera ganti sandi Anda!', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.red, fontStyle: FontStyle.italic)),
//               const SizedBox(height: 40),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   // Helper Widget untuk Field Input
//   Widget _buildTextField(String label, TextEditingController txtController, {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
//     return TextField(
//       controller: txtController,
//       obscureText: isPassword,
//       keyboardType: isNumber ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }
// }

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/profile_controller.dart';
// import '../settings/role_matrix_view.dart';

// void logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   Get.offAllNamed(Routes.LOGIN);
// }

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
//         final user = controller.userProfile.value;
//         if (controller.isLoading.value && user == null) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchProfile,
//           color: const Color(0xFF2563EB),
//           child: ListView(
//             padding: const EdgeInsets.all(20.0),
//             children: [
//               // Header Profil Singkat
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 36,
//                     backgroundColor: const Color(0xFF2563EB),
//                     child: Text(
//                       user?.initial ?? 'U',
//                       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user?.displayName ?? 'Pengguna',
//                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
//                         ),
//                         Text(
//                           '${user?.role ?? 'Staff'} / @${user?.username ?? ''}',
//                           style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),

//               // Tombol Khusus Admin / Direktur / Developer ke Matriks Hak Akses
//               if (user != null && user.canManageRoles) ...[
//                 InkWell(
//                   onTap: () => Get.to(() => const RoleMatrixView()),
//                   borderRadius: BorderRadius.circular(12),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.indigo.shade200),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.indigo.shade600,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
//                         ),
//                         const SizedBox(width: 12),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Matriks Hak Akses (RBAC)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14)),
//                               Text('Atur halaman yang dapat diakses tiap jabatan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                             ],
//                           ),
//                         ),
//                         const Icon(Icons.chevron_right, color: Color(0xFF475569)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],

//               const Text('Informasi Personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
//               _buildTextField('Nama Lengkap', controller.fullNameController),
//               const SizedBox(height: 12),
//               _buildTextField('Nama Panggilan (Wajib)', controller.nameController),
//               const SizedBox(height: 12),
//               _buildTextField('Nomor Telepon', controller.phoneController, isNumber: true),
//               const SizedBox(height: 12),
//               _buildTextField('Alamat Email', controller.emailController, isEmail: true),

//               const SizedBox(height: 24),
//               const Text('Keamanan & Kredensial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),
//               _buildTextField('Username', controller.usernameController),
//               const SizedBox(height: 12),
//               _buildTextField('Kata Sandi Baru (Opsional)', controller.passwordController, isPassword: true),
//               const SizedBox(height: 12),
//               _buildTextField('Ulangi Sandi Baru', controller.passwordConfirmController, isPassword: true),

//               const SizedBox(height: 24),
//               const Text('Preferensi Sistem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),

//               // Toggle Email
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.mail_outline, color: Color(0xFF2563EB)),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Notifikasi Email', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                           Text('Terima pemberitahuan ERP di inbox.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                         ],
//                       ),
//                     ),
//                     Switch(
//                       value: controller.emailNotifications.value,
//                       onChanged: (val) => controller.emailNotifications.value = val,
//                       activeColor: const Color(0xFF2563EB),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   onPressed: controller.isSaving.value ? null : controller.updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2563EB),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   icon: controller.isSaving.value
//                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : const Icon(Icons.save),
//                   label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 ),
//               ),

//               const SizedBox(height: 32),
//               const Text('Aktivitas Login Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//               const SizedBox(height: 12),

//               // Tabel Log / Riwayat Aktivitas Login
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE2E8F0)),
//                 ),
//                 child: controller.loginLogs.isEmpty
//                     ? const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Center(child: Text('Belum ada data login terekam.', style: TextStyle(color: Colors.grey))),
//                       )
//                     : Column(
//                         children: controller.loginLogs.map((log) {
//                           final parsedDate = DateTime.tryParse(log.createdAt);
//                           return ListTile(
//                             leading: Icon(log.isMobile ? Icons.smartphone : Icons.computer, color: const Color(0xFF64748B)),
//                             title: Text(log.ipAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
//                             subtitle: Text(
//                               parsedDate != null ? DateFormat('dd MMM yyyy, HH:mm').format(parsedDate) : log.createdAt,
//                               style: const TextStyle(fontSize: 11),
//                             ),
//                             trailing: const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
//                           );
//                         }).toList(),
//                       ),
//               ),
//               const SizedBox(height: 12),
//               const Text('Jika Anda melihat Alamat IP asing, segera ganti sandi Anda!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 10, color: Colors.red, fontStyle: FontStyle.italic)),
//               const SizedBox(height: 40),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController txtController,
//       {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
//     return TextField(
//       controller: txtController,
//       obscureText: isPassword,
//       keyboardType: isNumber ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/profile_controller.dart';
import '../settings/role_matrix_view.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Get.offAllNamed(Routes.LOGIN);
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                        color: online ? Colors.amber.shade900 : Colors.red.shade900,
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
                      child: const Text('Sync', style: TextStyle(fontWeight: FontWeight.bold)),
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

          // Konten Profil
          Expanded(
            child: Obx(() {
              final user = controller.userProfile.value;
              if (controller.isLoading.value && user == null) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              return RefreshIndicator(
                onRefresh: controller.fetchProfile,
                color: const Color(0xFF2563EB),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Header Profil Singkat
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(
                            user?.initial ?? 'U',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Pengguna',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                              ),
                              Text(
                                '${user?.role ?? 'Staff'} / @${user?.username ?? ''}',
                                style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Tombol Khusus Admin / Direktur / Developer ke Matriks Hak Akses
                    if (user != null && user.canManageRoles) ...[
                      InkWell(
                        onTap: () => Get.to(() => const RoleMatrixView()),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.indigo.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Matriks Hak Akses (RBAC)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14)),
                                    Text('Atur halaman yang dapat diakses tiap jabatan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF475569)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    const Text('Informasi Personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),
                    _buildTextField('Nama Lengkap', controller.fullNameController),
                    const SizedBox(height: 12),
                    _buildTextField('Nama Panggilan (Wajib)', controller.nameController),
                    const SizedBox(height: 12),
                    _buildTextField('Nomor Telepon', controller.phoneController, isNumber: true),
                    const SizedBox(height: 12),
                    _buildTextField('Alamat Email', controller.emailController, isEmail: true),

                    const SizedBox(height: 24),
                    const Text('Keamanan & Kredensial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),
                    _buildTextField('Username', controller.usernameController),
                    const SizedBox(height: 12),
                    _buildTextField('Kata Sandi Baru (Opsional)', controller.passwordController, isPassword: true),
                    const SizedBox(height: 12),
                    _buildTextField('Ulangi Sandi Baru', controller.passwordConfirmController, isPassword: true),

                    const SizedBox(height: 24),
                    const Text('Preferensi Sistem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),

                    // Toggle Email
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline, color: Color(0xFF2563EB)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Notifikasi Email', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                Text('Terima pemberitahuan ERP di inbox.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Switch(
                            value: controller.emailNotifications.value,
                            onChanged: (val) => controller.emailNotifications.value = val,
                            activeColor: const Color(0xFF2563EB),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.isSaving.value ? null : controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: controller.isSaving.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save),
                        label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Text('Aktivitas Login Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),

                    // Tabel Log / Riwayat Aktivitas Login
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: controller.loginLogs.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: Text('Belum ada data login terekam.', style: TextStyle(color: Colors.grey))),
                            )
                          : Column(
                              children: controller.loginLogs.map((log) {
                                final parsedDate = DateTime.tryParse(log.createdAt);
                                return ListTile(
                                  leading: Icon(log.isMobile ? Icons.smartphone : Icons.computer, color: const Color(0xFF64748B)),
                                  title: Text(log.ipAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                                  subtitle: Text(
                                    parsedDate != null ? DateFormat('dd MMM yyyy, HH:mm').format(parsedDate) : log.createdAt,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  trailing: const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
                                );
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Jika Anda melihat Alamat IP asing, segera ganti sandi Anda!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.red, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController txtController,
      {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
    return TextField(
      controller: txtController,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}