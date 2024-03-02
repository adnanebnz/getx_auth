class RoomModel {
  String uid;
  String? name;
  List<dynamic> members = [];
  List<dynamic> messages = [];

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
      members: List<String>.from(json['members']),
      // Change here
      messages: List<String>.from(json['messages']), // Change here
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'createdAt': createdAt,
      'members': members, // Change here
      'messages': messages, // Change here
    };
  }

  @override
  String toString() {
    return 'RoomModel{uid: $uid, name: $name, members: $members, messages: $messages, createdAt: $createdAt}';
  }
}
