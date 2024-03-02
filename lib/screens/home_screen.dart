import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controllers/auth_controller.dart';
import 'package:flutter_firebase_app/controllers/chat_controller.dart';
import 'package:flutter_firebase_app/controllers/theme_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ChatController chatController = Get.find<ChatController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            Obx(() {
              return IconButton(
                icon: themeController.isDark.value
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
                onPressed: () => themeController.changeTheme(),
              );
            })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final users = snapshot.data?.docs;

              return Obx(() {
                users?.removeWhere(
                    (user) => user.id == authController.user.value.uid);
                return ListView.builder(
                  itemCount: users?.length,
                  itemBuilder: (context, index) {
                    final user = users?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user?['photoURL'] ?? ''),
                      ),
                      title: Text(user?['displayName']),
                      onTap: () {
                        chatController.room.value.name =
                            'Chat with ${user?['displayName']}';
                        chatController.createOrFindRoom(user?['uid']);
                      },
                    );
                  },
                );
              });
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            authController.signOut();
          },
          child: const Icon(Icons.logout),
        ));
  }
}
