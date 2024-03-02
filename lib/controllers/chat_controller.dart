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
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxString message = ''.obs;
  RxString roomName = ''.obs;
  RxString roomId = ''.obs;
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
    _performRoomAction(_chatService.createOrFindRoom(roomName.value, memberId));
  }

  void deleteRoom() async {
    _performChatAction(_chatService.deleteRoom(roomId.value), 'Room deletion');
  }

  void addPersonToRoom(String personId) async {
    _performChatAction(
        _chatService.addMemberToRoom(roomId.value, personId), 'Add person');
  }

  void removePersonToRoom(String personId) async {
    _performChatAction(
        _chatService.addMemberToRoom(roomId.value, personId), 'Remove person');
  }

  //sendMessage
  void sendMessage(String authorId) async {
    _performChatAction(
        _chatService.sendMessage(roomId.value, message.value, authorId),
        'Send message');
  }

  // Retrieve messages
  Stream<List<MessageModel>> getMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
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
    _performChatAction(_chatService.markMessageAsSeen(roomId.value, messageId),
        'Mark as seen');
  }

  //get room members
  void getRoomMembers() async {
    _performUserAction(_chatService.getRoomMembers(roomId.value));
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
      roomId.value = roomModel.uid;
      room.value = roomModel;
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
