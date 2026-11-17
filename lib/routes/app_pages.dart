import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/layout/main_layout.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const MAIN_LAYOUT = '/layout';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.MAIN_LAYOUT,
      page: () => const MainLayout(),
    ),
  ];
}