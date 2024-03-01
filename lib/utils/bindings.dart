import 'package:flutter_firebase_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {}
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    AuthBindings().dependencies();
    HomeBindings().dependencies();
  }
}
