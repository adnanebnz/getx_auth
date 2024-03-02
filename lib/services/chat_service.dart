import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_app/models/message_model.dart';
import 'package:flutter_firebase_app/models/room_model.dart';
import 'package:flutter_firebase_app/models/user_model.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<RoomModel> createRoom(String? name, String memberId) async {
    try {
      final room = await _firestore.collection('rooms').add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'members': [_auth.currentUser!.uid, memberId],
        'messages': [],
      });

      return RoomModel(
        uid: room.id,
        name: name ?? "",
        createdAt: DateTime.now(),
        members: [],
        messages: [],
      );
    } catch (e) {
      print(e);

      return RoomModel(
        uid: '',
        name: '',
        createdAt: DateTime.now(),
        members: [],
        messages: [],
      );
    }
  }

  //delete room
  Future<void> deleteRoom(String roomId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).delete();
    } catch (e) {
      print(e);
    }
  }

  //add person to room
  Future<void> addMemberToRoom(String roomId, String personId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'members': FieldValue.arrayUnion([personId]),
      });
    } catch (e) {
      print(e);
    }
  }

  //remove person from room
  Future<void> removePersonFromRoom(String roomId, String personId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'members': FieldValue.arrayRemove([personId]),
      });
    } catch (e) {
      print(e);
    }
  }

  //send message
  Future<void> sendMessage(
      String roomId, String message, String authorId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'messages': FieldValue.arrayUnion([
          {
            'uid': _auth.currentUser!.uid,
            'message': message,
            'author': authorId,
            'createdAt': FieldValue.serverTimestamp(),
            'isSeen': false,
          }
        ]),
      });
    } catch (e) {
      print(e);
    }
  }

  //mark message as seen
  Future<void> markMessageAsSeen(String roomId, String messageId) async {
    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .update({
            'messages': FieldValue.arrayUnion([
              {
                'uid': _auth.currentUser!.uid,
                'isSeen': true,
              }
            ]),
          })
          .then((value) => print('Message marked as seen'))
          .catchError(
              (error) => print('Failed to mark message as seen: $error'));
    } catch (e) {
      print(e);
    }
  }

  //get room messages
  Future<List<MessageModel>?> getRoomMessages(String roomId) async {
    try {
      final room = await _firestore.collection('rooms').doc(roomId).get();
      final messages = room.get('messages') as List<dynamic>;

      return messages
          .map<MessageModel>((message) => MessageModel.fromJson(message))
          .toList();
    } catch (e) {
      print(e);

      return null;
    }
  }

  //get room members
  Future<List<UserModel>?> getRoomMembers(String roomId) async {
    try {
      final room = await _firestore.collection('rooms').doc(roomId).get();
      final members = room.get('members') as List<dynamic>;

      return members
          .map<UserModel>((member) => UserModel.fromJson(member))
          .toList();
    } catch (e) {
      print(e);

      return null;
    }
  }
}
