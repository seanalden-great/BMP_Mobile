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
//                         color: online ? Colors.amber.shade900 : Colors.red.shade900,
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
//                       child: const Text('Sync', style: TextStyle(fontWeight: FontWeight.bold)),
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

//           // Konten Profil
//           Expanded(
//             child: Obx(() {
//               final user = controller.userProfile.value;
//               if (controller.isLoading.value && user == null) {
//                 return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchProfile,
//                 color: const Color(0xFF2563EB),
//                 child: ListView(
//                   padding: const EdgeInsets.all(20.0),
//                   children: [
//                     // Header Profil Singkat
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 36,
//                           backgroundColor: const Color(0xFF2563EB),
//                           child: Text(
//                             user?.initial ?? 'U',
//                             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 user?.displayName ?? 'Pengguna',
//                                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
//                               ),
//                               Text(
//                                 '${user?.role ?? 'Staff'} / @${user?.username ?? ''}',
//                                 style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),

//                     // Tombol Khusus Admin / Direktur / Developer ke Matriks Hak Akses
//                     if (user != null && user.canManageRoles) ...[
//                       InkWell(
//                         onTap: () => Get.to(() => const RoleMatrixView()),
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.indigo.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.indigo.shade200),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.indigo.shade600,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
//                               ),
//                               const SizedBox(width: 12),
//                               const Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Matriks Hak Akses (RBAC)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14)),
//                                     Text('Atur halaman yang dapat diakses tiap jabatan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                                   ],
//                                 ),
//                               ),
//                               const Icon(Icons.chevron_right, color: Color(0xFF475569)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],

//                     const Text('Informasi Personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),
//                     _buildTextField('Nama Lengkap', controller.fullNameController),
//                     const SizedBox(height: 12),
//                     _buildTextField('Nama Panggilan (Wajib)', controller.nameController),
//                     const SizedBox(height: 12),
//                     _buildTextField('Nomor Telepon', controller.phoneController, isNumber: true),
//                     const SizedBox(height: 12),
//                     _buildTextField('Alamat Email', controller.emailController, isEmail: true),

//                     const SizedBox(height: 24),
//                     const Text('Keamanan & Kredensial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),
//                     _buildTextField('Username', controller.usernameController),
//                     const SizedBox(height: 12),
//                     _buildTextField('Kata Sandi Baru (Opsional)', controller.passwordController, isPassword: true),
//                     const SizedBox(height: 12),
//                     _buildTextField('Ulangi Sandi Baru', controller.passwordConfirmController, isPassword: true),

//                     const SizedBox(height: 24),
//                     const Text('Preferensi Sistem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),

//                     // Toggle Email
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFFE2E8F0)),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.mail_outline, color: Color(0xFF2563EB)),
//                           const SizedBox(width: 12),
//                           const Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Notifikasi Email', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                                 Text('Terima pemberitahuan ERP di inbox.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//                               ],
//                             ),
//                           ),
//                           Switch(
//                             value: controller.emailNotifications.value,
//                             onChanged: (val) => controller.emailNotifications.value = val,
//                             activeColor: const Color(0xFF2563EB),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     SizedBox(
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         onPressed: controller.isSaving.value ? null : controller.updateProfile,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2563EB),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         icon: controller.isSaving.value
//                             ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                             : const Icon(Icons.save),
//                         label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                       ),
//                     ),

//                     const SizedBox(height: 32),
//                     const Text('Aktivitas Login Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),

//                     // Tabel Log / Riwayat Aktivitas Login
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFFE2E8F0)),
//                       ),
//                       child: controller.loginLogs.isEmpty
//                           ? const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Center(child: Text('Belum ada data login terekam.', style: TextStyle(color: Colors.grey))),
//                             )
//                           : Column(
//                               children: controller.loginLogs.map((log) {
//                                 final parsedDate = DateTime.tryParse(log.createdAt);
//                                 return ListTile(
//                                   leading: Icon(log.isMobile ? Icons.smartphone : Icons.computer, color: const Color(0xFF64748B)),
//                                   title: Text(log.ipAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
//                                   subtitle: Text(
//                                     parsedDate != null ? DateFormat('dd MMM yyyy, HH:mm').format(parsedDate) : log.createdAt,
//                                     style: const TextStyle(fontSize: 11),
//                                   ),
//                                   trailing: const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
//                                 );
//                               }).toList(),
//                             ),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text('Jika Anda melihat Alamat IP asing, segera ganti sandi Anda!',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 10, color: Colors.red, fontStyle: FontStyle.italic)),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
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

// import 'package:bmp_mobile/routes/app_pages.dart';
// import 'package:bmp_mobile/services/language_service.dart';
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
//     final langService = Get.find<LanguageService>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         title: Text('prof_title'.tr,
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

//           // Konten Profil
//           Expanded(
//             child: Obx(() {
//               final user = controller.userProfile.value;
//               if (controller.isLoading.value && user == null) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF2563EB)));
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.fetchProfile,
//                 color: const Color(0xFF2563EB),
//                 child: ListView(
//                   padding: const EdgeInsets.all(20.0),
//                   children: [
//                     // Header Profil Singkat
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 36,
//                           backgroundColor: const Color(0xFF2563EB),
//                           child: Text(
//                             user?.initial ?? 'U',
//                             style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 user?.displayName ?? 'prof_default_user'.tr,
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w900,
//                                     color: Color(0xFF1E293B)),
//                               ),
//                               Text(
//                                 '${user?.role ?? 'Staff'} / @${user?.username ?? ''}',
//                                 style: const TextStyle(
//                                     color: Color(0xFF64748B),
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),

//                     // Tombol Khusus Admin / Direktur / Developer ke Matriks Hak Akses
//                     if (user != null && user.canManageRoles) ...[
//                       InkWell(
//                         onTap: () => Get.to(() => const RoleMatrixView()),
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.indigo.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.indigo.shade200),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.indigo.shade600,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(Icons.admin_panel_settings,
//                                     color: Colors.white, size: 20),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('prof_rbac_title'.tr,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF1E293B),
//                                             fontSize: 14)),
//                                     Text('prof_rbac_sub'.tr,
//                                         style: const TextStyle(
//                                             fontSize: 11,
//                                             color: Color(0xFF64748B))),
//                                   ],
//                                 ),
//                               ),
//                               const Icon(Icons.chevron_right,
//                                   color: Color(0xFF475569)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],

//                     Text('prof_personal_info'.tr,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_full_name'.tr, controller.fullNameController),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_nickname_req'.tr, controller.nameController),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_phone'.tr, controller.phoneController,
//                         isNumber: true),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_email'.tr, controller.emailController,
//                         isEmail: true),

//                     const SizedBox(height: 24),
//                     Text('prof_security_cred'.tr,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_username'.tr, controller.usernameController),
//                     const SizedBox(height: 12),
//                     _buildTextField(
//                         'prof_new_password'.tr, controller.passwordController,
//                         isPassword: true),
//                     const SizedBox(height: 12),
//                     _buildTextField('prof_confirm_password'.tr,
//                         controller.passwordConfirmController,
//                         isPassword: true),

//                     const SizedBox(height: 24),
//                     Text('prof_sys_pref'.tr,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),

//                     // Toggle Email
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFFE2E8F0)),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.mail_outline,
//                               color: Color(0xFF2563EB)),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('prof_email_notif'.tr,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF1E293B))),
//                                 Text('prof_email_notif_sub'.tr,
//                                     style: const TextStyle(
//                                         fontSize: 11,
//                                         color: Color(0xFF64748B))),
//                               ],
//                             ),
//                           ),
//                           Switch(
//                             value: controller.emailNotifications.value,
//                             onChanged: (val) =>
//                                 controller.emailNotifications.value = val,
//                             activeColor: const Color(0xFF2563EB),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     SizedBox(
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         onPressed: controller.isSaving.value
//                             ? null
//                             : controller.updateProfile,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2563EB),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         icon: controller.isSaving.value
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white, strokeWidth: 2))
//                             : const Icon(Icons.save),
//                         label: Text('prof_save_changes'.tr,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                       ),
//                     ),

//                     const SizedBox(height: 32),
//                     Text('prof_last_login'.tr,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B))),
//                     const SizedBox(height: 12),

//                     // Tabel Log / Riwayat Aktivitas Login
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFFE2E8F0)),
//                       ),
//                       child: controller.loginLogs.isEmpty
//                           ? Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Center(
//                                   child: Text('prof_no_login_logs'.tr,
//                                       style:
//                                           const TextStyle(color: Colors.grey))),
//                             )
//                           : Column(
//                               children: controller.loginLogs.map((log) {
//                                 final parsedDate =
//                                     DateTime.tryParse(log.createdAt);
//                                 return ListTile(
//                                   leading: Icon(
//                                       log.isMobile
//                                           ? Icons.smartphone
//                                           : Icons.computer,
//                                       color: const Color(0xFF64748B)),
//                                   title: Text(log.ipAddress,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 13,
//                                           color: Color(0xFF1E293B))),
//                                   subtitle: Text(
//                                     parsedDate != null
//                                         ? DateFormat('dd MMM yyyy, HH:mm')
//                                             .format(parsedDate)
//                                         : log.createdAt,
//                                     style: const TextStyle(fontSize: 11),
//                                   ),
//                                   trailing: const Icon(Icons.shield_outlined,
//                                       color: Colors.green, size: 20),
//                                 );
//                               }).toList(),
//                             ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text('prof_ip_warning'.tr,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontSize: 10,
//                             color: Colors.red,
//                             fontStyle: FontStyle.italic)),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController txtController,
//       {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
//     return TextField(
//       controller: txtController,
//       obscureText: isPassword,
//       keyboardType: isNumber
//           ? TextInputType.phone
//           : (isEmail ? TextInputType.emailAddress : TextInputType.text),
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }
// }

import 'package:bmp_mobile/routes/app_pages.dart';
import 'package:bmp_mobile/services/language_service.dart';
import 'package:bmp_mobile/services/theme_service.dart';
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
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('prof_title'.tr,
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

          // Konten Profil
          Expanded(
            child: Obx(() {
              final user = controller.userProfile.value;
              if (controller.isLoading.value && user == null) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)));
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
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'prof_default_user'.tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: textPrimary),
                              ),
                              Text(
                                '${user?.role ?? 'Gudang'} / @${user?.username ?? ''}',
                                style: TextStyle(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w600),
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
                            color: isDark
                                ? Colors.indigo.shade900.withOpacity(0.35)
                                : Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isDark
                                    ? Colors.indigo.shade700
                                    : Colors.indigo.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.admin_panel_settings,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('prof_rbac_title'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textPrimary,
                                            fontSize: 14)),
                                    Text('prof_rbac_sub'.tr,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: textSecondary)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    Text('prof_personal_info'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    const SizedBox(height: 12),
                    _buildTextField('prof_full_name'.tr,
                        controller.fullNameController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField('prof_nickname_req'.tr,
                        controller.nameController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField(
                        'prof_phone'.tr, controller.phoneController, isDark,
                        isNumber: true),
                    const SizedBox(height: 12),
                    _buildTextField(
                        'prof_email'.tr, controller.emailController, isDark,
                        isEmail: true),

                    const SizedBox(height: 24),
                    Text('prof_security_cred'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    const SizedBox(height: 12),
                    _buildTextField('prof_username'.tr,
                        controller.usernameController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField('prof_new_password'.tr,
                        controller.passwordController, isDark,
                        isPassword: true),
                    const SizedBox(height: 12),
                    _buildTextField('prof_confirm_password'.tr,
                        controller.passwordConfirmController, isDark,
                        isPassword: true),

                    const SizedBox(height: 24),
                    Text('prof_sys_pref'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    const SizedBox(height: 12),

                    // Toggle Email
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline,
                              color: Color(0xFF3B82F6)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('prof_email_notif'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary)),
                                Text('prof_email_notif_sub'.tr,
                                    style: TextStyle(
                                        fontSize: 11, color: textSecondary)),
                              ],
                            ),
                          ),
                          Switch(
                            value: controller.emailNotifications.value,
                            onChanged: (val) =>
                                controller.emailNotifications.value = val,
                            activeColor: const Color(0xFF2563EB),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: controller.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save),
                        label: Text('prof_save_changes'.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 32),
                    Text('prof_last_login'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    const SizedBox(height: 12),

                    // Tabel Log / Riwayat Aktivitas Login
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: controller.loginLogs.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                  child: Text('prof_no_login_logs'.tr,
                                      style: TextStyle(color: textSecondary))),
                            )
                          : Column(
                              children: controller.loginLogs.map((log) {
                                final parsedDate =
                                    DateTime.tryParse(log.createdAt);
                                return ListTile(
                                  leading: Icon(
                                      log.isMobile
                                          ? Icons.smartphone
                                          : Icons.computer,
                                      color: textSecondary),
                                  title: Text(log.ipAddress,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: textPrimary)),
                                  subtitle: Text(
                                    parsedDate != null
                                        ? DateFormat('dd MMM yyyy, HH:mm')
                                            .format(parsedDate)
                                        : log.createdAt,
                                    style: TextStyle(
                                        fontSize: 11, color: textSecondary),
                                  ),
                                  trailing: Icon(Icons.shield_outlined,
                                      color: isDark
                                          ? Colors.green.shade400
                                          : Colors.green,
                                      size: 20),
                                );
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text('prof_ip_warning'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.red.shade300 : Colors.red,
                            fontStyle: FontStyle.italic)),
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

  Widget _buildTextField(
      String label, TextEditingController txtController, bool isDark,
      {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return TextField(
      controller: txtController,
      obscureText: isPassword,
      style: TextStyle(
          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B)),
      keyboardType: isNumber
          ? TextInputType.phone
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}