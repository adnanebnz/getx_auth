import 'package:flutter_firebase_app/models/user_model.dart';

import 'message_model.dart';

class RoomModel {
  String uid;
  String? name;
  List<UserModel> members = [];
  List<MessageModel> messages = [];

  DateTime createdAt;
  RoomModel({
    required this.uid,
    this.name,
    required this.createdAt,
    required this.members,
    required this.messages,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      uid: json['uid'],
      name: json['name'],
      createdAt: json['createdAt'].toDate(),
      members: json['members']
          .map<UserModel>((member) => UserModel.fromJson(member))
          .toList(),
      messages: json['messages']
          .map<MessageModel>((message) => MessageModel.fromJson(message))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'createdAt': createdAt,
      'members': members.map((member) => member.toJson()).toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
