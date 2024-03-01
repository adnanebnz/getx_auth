import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/models/UserModel.dart';
import 'dart:developer' show log;

import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString displayName = ''.obs;
  RxBool isLoading = false.obs;
  Rx<XFile> profilePicture = XFile('').obs;

  Rx<UserModel> user = UserModel(
    uid: "",
    email: "",
    emailVerified: false,
    password: "",
    displayName: "",
    photoURL: "",
  ).obs;

  final AuthService _authService = AuthService();

  void signInWithEmailAndPassword(String email, String password) async {
    _performAction(
        _authService.signInWithEmailAndPassword(email, password), 'Login');
  }

  void signOut() async {
    _performAuthAction(_authService.signOut(), 'Sign out');
  }

  void createAccount() async {
    _performAuthAction(
        _authService.createAccount(email.value, password.value,
            profilePicture.value, displayName.value),
        'Account creation');
  }

  void resetPassword() async {
    _performAuthAction(
        _authService.resetPassword(email.value), 'Password reset');
  }

  void updateEmail() async {
    _performAuthAction(_authService.updateEmail(email.value), 'Email update');
  }

  void updatePassword() async {
    _performAuthAction(
        _authService.updatePassword(password.value), 'Password update');
  }

  void deleteAccount() async {
    _performAuthAction(_authService.deleteAccount(), 'Account deletion');
  }

  void signInWithGoogle() async {
    _performAuthAction(_authService.signInWithGoogle(), 'Sign in with Google');
  }

  void _performAction(Future<UserModel> action, String name) async {
    try {
      isLoading.value = true;
      UserModel userModel = await action;

      user.value = userModel;
      user.refresh(); // Notify the listeners about the change

      //display success message
      Get.snackbar(
        'Success',
        '$name completed successfully',
        isDismissible: true,
        margin: const EdgeInsets.all(8),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        barBlur: 20,
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _performAuthAction(Future action, String name) async {
    try {
      isLoading.value = true;
      await action;
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        user.update((val) {
          val?.uid = firebaseUser.uid;
          val?.email = firebaseUser.email!;
          val?.emailVerified = firebaseUser.emailVerified;
          val?.displayName = firebaseUser.displayName!;
          val?.photoURL = firebaseUser.photoURL!;
        });
      }
      //display success message
      Get.snackbar(
        'Success',
        '$name completed successfully',
        isDismissible: true,
        margin: const EdgeInsets.all(8),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        barBlur: 20,
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic error) {
    String message = 'An error occurred. Please try again later.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'user-disabled':
          message = 'User with this email has been disabled.';
          break;
        default:
          message = error.message ?? message;
      }
    }

    Get.snackbar(
      'Error',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      barBlur: 20,
      isDismissible: true,
      margin: const EdgeInsets.all(8),
      dismissDirection: DismissDirection.horizontal,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
