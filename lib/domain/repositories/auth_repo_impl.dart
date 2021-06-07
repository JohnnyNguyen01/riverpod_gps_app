import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuthImpl>((ref) {
  return FirebaseAuthImpl();
});

class FirebaseAuthImpl implements AuthRepository {
  final _authInstance = FirebaseAuth.instance;

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authInstance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signupWithEmailAndPassword(String email, String password) async {
    try {
      await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  User? getUser() {
    try {
      return _authInstance.currentUser;
    } on FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message!);
    }
  }
}
