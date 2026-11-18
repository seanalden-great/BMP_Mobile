import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart'; // <--- Import ini
import '../views/layout/main_layout.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register'; // <--- Tambahkan konstanta ini
  static const MAIN_LAYOUT = '/layout';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.REGISTER, // <--- Daftarkan di sini
      page: () => const RegisterView(),
    ),
    GetPage(
      name: Routes.MAIN_LAYOUT,
      page: () => const MainLayout(),
    ),
  ];
}