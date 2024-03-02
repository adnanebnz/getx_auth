import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  RxBool isDark = false.obs;

  void changeTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      isDark.value = false;
    } else {
      _themeMode = ThemeMode.dark;
      isDark.value = true;
    }
    Get.changeThemeMode(_themeMode);
    update();
  }
}
