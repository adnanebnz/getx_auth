import 'dart:io';

class TaskModel {
  String? uid;
  String title;
  bool isDone;
  String file_url;
  File? file;

  TaskModel(
      {this.uid,
      required this.title,
      this.isDone = false,
      this.file,
      required this.file_url});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'isDone': isDone,
      'file_url': file_url,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      uid: map['uid'],
      title: map['title'],
      isDone: map['isDone'],
      file_url: map['file_url'],
    );
  }
}
