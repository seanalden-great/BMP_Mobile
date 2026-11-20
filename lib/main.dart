import 'package:bmp_mobile/services/language_service.dart';
import 'package:bmp_mobile/services/sync_service.dart';
import 'package:bmp_mobile/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import kerangka rute (akan dibuat setelah ini)
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah user sudah login sebelumnya dengan membaca Token di lokal HP
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  final String initialRoute =
      (token != null && token.isNotEmpty) ? Routes.MAIN_LAYOUT : Routes.LOGIN;

  await Get.putAsync(() => SyncService().init());
  await Get.putAsync(() => LanguageService().init());

  runApp(BMPErpApp(initialRoute: initialRoute));
}

class BMPErpApp extends StatelessWidget {
  const BMPErpApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final langService = Get.find<LanguageService>();

    return GetMaterialApp(
      title: 'BMP ERP Mobile',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: langService.currentLocale.value,
      fallbackLocale: const Locale('id', 'ID'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Tailwind Blue-600
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute, // Jalur yang ditentukan dari hasil cek sesi
      getPages: AppPages.routes, // Memanggil daftar jalan/rute
    );
  }
}
