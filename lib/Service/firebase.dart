import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/firebase_model.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// REGISTER USER
  Future<UserFirebaseModel> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final userModel = UserFirebaseModel(
      uid: uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore.collection("users").doc(uid).set(userModel.toMap());

    return userModel;
  }

  /// LOGIN USER
  Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final snap = await firestore.collection("users").doc(uid).get();

    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap(snap.data()!);
  }

  /// UPDATE PROFILE (username & email)
  /// UPDATE USERNAME ONLY
  Future<void> updateUsername({
    required String uid,
    required String newUsername,
  }) async {
    await firestore.collection("users").doc(uid).update({
      "username": newUsername,
      "updateAt": DateTime.now().toIso8601String(),
    });
  }
}

final firebaseService = FirebaseService();
