import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_app/models/message_model.dart';
import 'package:flutter_firebase_app/models/room_model.dart';
import 'package:flutter_firebase_app/models/user_model.dart';
import 'package:flutter_firebase_app/services/chat_service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserModel> members = <UserModel>[].obs;
  RxString message = ''.obs;
  Rx<RoomModel> room = RoomModel(
    uid: '',
    name: '',
    createdAt: DateTime.now(),
    members: [],
    messages: [],
  ).obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ChatService _chatService = ChatService();

  void createOrFindRoom(String memberId) async {
    _performRoomAction(
        _chatService.createOrFindRoom(room.value.name, memberId));
  }

  void deleteRoom() async {
    _performChatAction(
        _chatService.deleteRoom(room.value.uid), 'Room deletion');
  }

  void addPersonToRoom(String personId) async {
    _performChatAction(
        _chatService.addMemberToRoom(room.value.uid, personId), 'Add person');
  }

  void removePersonToRoom(String personId) async {
    _performChatAction(_chatService.addMemberToRoom(room.value.uid, personId),
        'Remove person');
  }

  //sendMessage
  void sendMessage(String authorId) async {
    _performChatAction(
        _chatService.sendMessage(room.value.uid, message.value, authorId),
        'Send message');
  }

  // Retrieve messages
  Stream<List<MessageModel>> getMessages(String room) {
    return _firestore
        .collection('rooms')
        .doc(room)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              // log("DOC author uid : ${doc.data()['uid']}");
              return MessageModel(
                uid: doc['uid'],
                message: doc['message'],
                author: UserModel.fromJson(doc['author']),
                createdAt: doc['createdAt'].toDate(),
                isSeen: doc['isSeen'],
              );
            }).toList());
  }

  //mark message as seen
  void markMessageAsSeen(String messageId) async {
    _performChatAction(
        _chatService.markMessageAsSeen(room.value.uid, messageId),
        'Mark as seen');
  }

  //get room members
  void getRoomMembers() async {
    _performUserAction(_chatService.getRoomMembers(room.value.uid));
  }

  // ! HELPER FUNCS

  void _performUserAction(Future<List<UserModel>?> action) async {
    try {
      isLoading.value = true;
      List<UserModel>? usersList = await action;
      if (usersList != null) {
        members.value = usersList;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _performRoomAction(Future<RoomModel> action) async {
    try {
      isLoading.value = true;
      RoomModel roomModel = await action;
      room.value.uid = roomModel.uid;
      room.value = roomModel;
      Get.toNamed("/chat");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _performChatAction(Future<void> action, String actionName) async {
    try {
      isLoading.value = true;
      await action;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
