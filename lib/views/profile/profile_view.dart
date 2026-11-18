import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate-100
      body: Obx(() {
        if (controller.isLoading.value && controller.userProfile.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        final user = controller.userProfile;

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
                      (user['name'] ?? 'U').toString().substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['full_name'] ?? user['name'] ?? 'Pengguna', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                        Text('${user['role'] ?? 'Staff'} / @${user['username']}', style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

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
                    ? const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('Belum ada data login terekam.', style: TextStyle(color: Colors.grey))))
                    : Column(
                        children: controller.loginLogs.map((log) {
                          bool isMobile = log['user_agent'].toString().toLowerCase().contains('mobile');
                          return ListTile(
                            leading: Icon(isMobile ? Icons.smartphone : Icons.computer, color: const Color(0xFF64748B)),
                            title: Text(log['ip_address'] ?? 'Unknown IP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                            subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(log['created_at'])), style: const TextStyle(fontSize: 11)),
                            trailing: const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 12),
              const Text('Jika Anda melihat Alamat IP asing, segera ganti sandi Anda!', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.red, fontStyle: FontStyle.italic)),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // Helper Widget untuk Field Input
  Widget _buildTextField(String label, TextEditingController txtController, {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
    return TextField(
      controller: txtController,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}