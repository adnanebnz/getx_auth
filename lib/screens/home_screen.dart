import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AuthController authController = Get.find<AuthController>();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Obx(() {
          if (authController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(authController.user.value.photoURL),
                  Text("Welcome! ${authController.user.value.displayName}"),
                  FilledButton(
                      onPressed: () {
                        authController.signOut();
                      },
                      child: const Text("Logout")),
                ],
              ),
            );
          }
        }));
  }
}
