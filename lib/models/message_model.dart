import 'package:flutter_firebase_app/models/user_model.dart';

class MessageModel {
  String uid;
  String message;
  UserModel author;
  DateTime createdAt;
  bool isSeen;

  MessageModel({
    required this.uid,
    required this.message,
    required this.author,
    required this.createdAt,
    required this.isSeen,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      uid: json['uid'],
      message: json['message'],
      author: UserModel.fromJson(json['author']),
      createdAt: json['createdAt'].toDate(),
      isSeen: json['isSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'message': message,
      'author': author.toJson(),
      'createdAt': createdAt,
      'isSeen': isSeen,
    };
  }
}
