import 'package:flutter_firebase_app/screens/login_screen.dart';
import 'package:flutter_firebase_app/screens/register_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/screens/home_screen.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
    ),
  ];
}
