import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signupWithEmailAndPassword(
      String email, String password) async {}

  Future<void> loginWithEmailAndPassword(String email, String password) async {}

  Future<void> signOut() async {}

  User? getUser() {}
}
