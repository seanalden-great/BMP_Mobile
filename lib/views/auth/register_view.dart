// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/register_controller.dart';

// class RegisterView extends StatelessWidget {
//   const RegisterView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RegisterController());
    
//     // Set default role saat halaman dimuat
//     controller.selectedRole.value = 'Gudang';

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: const Text('Registrasi Karyawan'),
//         backgroundColor: Colors.transparent,
//         foregroundColor: const Color(0xFF1E293B),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   'Buat Akun Baru',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Daftarkan kredensial ERP Anda untuk mendapatkan akses ke dalam sistem perusahaan.',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
//                 ),
//                 const SizedBox(height: 32),

//                 // Form Nama Lengkap
//                 _buildTextField('Nama Lengkap', Icons.badge_outlined, controller.fullNameController),
//                 const SizedBox(height: 16),

//                 // Form Username
//                 _buildTextField('Username (Untuk Login)', Icons.person_outline, controller.usernameController),
//                 const SizedBox(height: 16),

//                 // Form Email
//                 _buildTextField('Alamat Email (Opsional)', Icons.email_outlined, controller.emailController, isEmail: true),
//                 const SizedBox(height: 16),

//                 // Dropdown Hak Akses (Role)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Obx(() => DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: controller.selectedRole.value,
//                       isExpanded: true,
//                       icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2563EB)),
//                       items: ['Admin', 'Gudang', 'Developer', 'Direktur'].map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text('Hak Akses: $value', style: const TextStyle(fontWeight: FontWeight.w600)),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         if (newValue != null) controller.selectedRole.value = newValue;
//                       },
//                     ),
//                   )),
//                 ),
//                 const SizedBox(height: 16),

//                 // Form Kata Sandi
//                 Obx(() => TextField(
//                   controller: controller.passwordController,
//                   obscureText: !controller.isPasswordVisible.value,
//                   decoration: InputDecoration(
//                     labelText: 'Kata Sandi (Min. 6 Karakter)',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility),
//                       onPressed: controller.togglePasswordVisibility,
//                     ),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 )),
//                 const SizedBox(height: 40),

//                 // Tombol Daftar
//                 Obx(() => ElevatedButton(
//                   onPressed: controller.isLoading.value ? null : controller.register,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF10B981), // Emerald-500
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                   ),
//                   child: controller.isLoading.value
//                       ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : const Text('DAFTARKAN AKUN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
//                 )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, IconData icon, TextEditingController txtController, {bool isEmail = false}) {
//     return TextField(
//       controller: txtController,
//       keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Registrasi Karyawan'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftarkan kredensial ERP Anda untuk mendapatkan akses ke dalam sistem perusahaan.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 32),

                // Form Nama Lengkap
                _buildTextField('Nama Lengkap', Icons.badge_outlined, controller.regFullNameController),
                const SizedBox(height: 16),

                // Form Username
                _buildTextField('Username (Untuk Login)', Icons.person_outline, controller.regUsernameController),
                const SizedBox(height: 16),

                // Form Email
                _buildTextField('Alamat Email (Opsional)', Icons.email_outlined, controller.regEmailController, isEmail: true),
                const SizedBox(height: 16),

                // Dropdown Hak Akses (Role)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedRole.value,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2563EB)),
                      // items: ['Admin', 'Gudang', 'Developer', 'Direktur'].map((String value) {
                      //   return DropdownMenuItem<String>(
                      //     value: value,
                      //     child: Text('Hak Akses: $value', style: const TextStyle(fontWeight: FontWeight.w600)),
                      //   );
                      // }).toList(),
                      items: [
                        'Admin',
                        'Direktur',
                        'HEAD/SPV',
                        'Purchasing',
                        'Gudang',
                        'Developer',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Hak Akses: $value',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) controller.selectedRole.value = newValue;
                      },
                    ),
                  )),
                ),
                const SizedBox(height: 16),

                // Form Kata Sandi
                Obx(() => TextField(
                  controller: controller.regPasswordController,
                  obscureText: !controller.isRegPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi (Min. 6 Karakter)',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isRegPasswordVisible.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: controller.toggleRegPasswordVisibility,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )),
                const SizedBox(height: 40),

                // Tombol Daftar
                Obx(() => ElevatedButton(
                  onPressed: controller.isRegLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: controller.isRegLoading.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('DAFTARKAN AKUN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController txtController, {bool isEmail = false}) {
    return TextField(
      controller: txtController,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}