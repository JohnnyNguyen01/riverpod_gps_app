import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  final authRepo = ref.read(firebaseAuthProvider);
  final dbRepo = ref.read(databaseRepoImplProvider);
  return UserStateNotifier(
    gpsRepo: gpsRepo,
    authRepo: authRepo,
    dbRepo: dbRepo,
  );
});

/*
 * State events
 */
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  final UserModel initialUser;
  const UserInitial()
      : initialUser = const UserModel(
          email: "",
          userName: "",
          location: LatLng(0, 0),
          uid: '',
        );
}

class UserLoggingIn extends UserState {
  const UserLoggingIn();
}

class UserLoggedIn extends UserState {
  final UserModel user;
  const UserLoggedIn({required this.user});
}

class UserLoggingOut extends UserState {
  const UserLoggingOut();
}

//todo: currently throwing Failure() on exceptions
class UserError extends UserState {
  final String error;
  UserError({required this.error});
}

/*
 * State Notifier
 */
class UserStateNotifier extends StateNotifier<UserState> {
  final DeviceGps _gpsRepo;
  final AuthRepository _authRepo;
  final DatabaseRepository _dbRepo;

  UserStateNotifier(
      {required DeviceGps gpsRepo,
      required AuthRepository authRepo,
      required DatabaseRepository dbRepo})
      : _gpsRepo = gpsRepo,
        _authRepo = authRepo,
        _dbRepo = dbRepo,
        super(const UserInitial());

  Future<void> loginuser(
      {required String email,
      required String name,
      required String password}) async {
    try {
      state = const UserLoggingIn();
      log(state.toString());
      await _authRepo.loginWithEmailAndPassword(email, password);
      final userPosition = await _gpsRepo.getDevicePosition();
      final userLatLng = LatLng(userPosition.latitude, userPosition.longitude);
      final user = UserModel(
          email: email,
          userName: name,
          location: userLatLng,
          uid: _authRepo.getUser()!.uid);
      state = UserLoggedIn(user: user);
      log("User Logged In Successfully: ${user.toString()}");
    } on FirebaseAuthException catch (e) {
      state = UserError(error: e.message!);
      throw Failure(code: e.code, message: e.message);
    } //todo add other failures
  }

  ///Sign's up a new user to Firebase, and creates a new document in `Users`
  ///collection. User app state is then set to the new user.
  //todo: Check network exceptions
  Future<void> signupUser(
      {required String email,
      required String name,
      required String password}) async {
    try {
      state = const UserLoggingIn();
      log(state.toString());
      final userPos = await _gpsRepo.getDevicePosition();
      final userLatLng = LatLng(userPos.latitude, userPos.longitude);
      await _authRepo.signupWithEmailAndPassword(email, password);
      //set state
      final user = UserModel(
          email: email,
          userName: name,
          location: userLatLng,
          uid: _authRepo.getUser()!.uid);
      state = UserLoggedIn(user: user);
      log(state.toString());
      //add new doc to firestore
      await _dbRepo.addNewUser(user: user);
      log("User Signed Up Successfully: ${user.toString()}");
    } on FirebaseAuthException catch (e) {
      state = UserError(error: e.message!);
      log(state.toString());
      throw Failure(code: e.code, message: e.message!);
    }
  }

  ///logout the current usedr
  void logoutUser() async {
    state = const UserLoggingOut();
    log(state.toString());
    await _authRepo.signOut();
    state = const UserInitial();
    log(state.toString());
  }
}
