import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controllers/chat_controller.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController _chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Obx(() {
        if (_chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: _chatController.messages.length,
            itemBuilder: (context, index) {
              final message = _chatController.messages[index];
              return ListTile(
                title: Text(message.message),
                subtitle: Text('Sent by ${message.author.displayName}'),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // This could open a dialog or another screen for the user to enter a new message
          _chatController.sendMessage('Hello, world!');
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
