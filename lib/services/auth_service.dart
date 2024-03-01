import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' show log;

import '../models/UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    //get user data from firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    // Convert the DocumentSnapshot to a UserModel
    UserModel userModel = UserModel.fromDocumentSnapshot(userDoc);
    log(userModel.toString());

    return userModel;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createAccount(
    String email,
    String password,
    XFile profilePicture,
    String displayName,
  ) async {
    //image upload
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = _storage.ref().child('profilePictures/$fileName');
    UploadTask uploadTask = reference.putFile(
      File(profilePicture.path),
    );
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String photoURL = await storageTaskSnapshot.ref.getDownloadURL();

    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email': email,
      'photoURL': photoURL,
      'displayName': displayName,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateEmail(String email) async {
    await _auth.currentUser?.verifyBeforeUpdateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredentials =
        await _auth.signInWithCredential(credential);

    if (userCredentials.additionalUserInfo!.isNewUser) {
      _firestore.collection('users').doc(userCredentials.user!.uid).set({
        'email': userCredentials.user!.email,
        'photoURL': userCredentials.user!.photoURL,
        'displayName': userCredentials.user!.displayName,
        'createdAt': DateTime.now(),
      });
      return userCredentials.user;
    }
  }
}
