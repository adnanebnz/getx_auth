class UserModel {
  String uid;
  String displayName;
  bool emailVerified = false;
  String photoURL = "";
  String email;
  String? password;

  UserModel(
      {required this.uid,
      required this.displayName,
      required this.emailVerified,
      required this.photoURL,
      required this.email,
      this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      emailVerified: json['emailVerified'],
      photoURL: json['photoURL'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'photoURL': photoURL,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, displayName: $displayName, emailVerified: $emailVerified, photoURL: $photoURL, email: $email, password: $password}';
  }
}
