import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      displayName: doc['displayName'] ?? '',
      emailVerified: doc['emailVerified'],
      photoURL: doc['photoURL'] ?? '',
      email: doc['email'] ?? '',
      password: null, // Firestore DocumentSnapshot doesn't contain password
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName ?? '',
      emailVerified: user.emailVerified,
      photoURL: user.photoURL ?? '',
      email: user.email ?? '',
      password: null, // Firebase User object doesn't contain password
    );
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, displayName: $displayName, emailVerified: $emailVerified, photoURL: $photoURL, email: $email, password: $password}';
  }
}
