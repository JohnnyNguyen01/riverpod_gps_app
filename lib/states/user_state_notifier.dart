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
  return UserStateNotifier(gpsRepo: gpsRepo, authRepo: authRepo);
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
      : initialUser =
            const UserModel(email: "", userName: "", location: LatLng(0, 0));
}

class UserLoggingIn extends UserState {
  const UserLoggingIn();
}

class UserLoggedIn extends UserState {
  final UserModel user;
  const UserLoggedIn({required this.user});
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

  UserStateNotifier(
      {required DeviceGps gpsRepo, required AuthRepository authRepo})
      : _gpsRepo = gpsRepo,
        _authRepo = authRepo,
        super(const UserInitial());

  Future<void> loginuser(
      {required String email,
      required String name,
      required String password}) async {
    //set state to loading
    //login user
    //set user to new state
    try {
      state = const UserLoggingIn();
      await _authRepo.loginWithEmailAndPassword(email, password);
      final userPosition = await _gpsRepo.getDevicePosition();
      final userLatLng = LatLng(userPosition.latitude, userPosition.longitude);
      final user =
          UserModel(email: email, userName: name, location: userLatLng);
      state = UserLoggedIn(user: user);
    } on FirebaseAuthException catch (e) {
      state = UserError(error: e.message!);
      throw Failure(code: e.code, message: e.message);
    }
  }

  ///Set the user's location [LatLng] to their current location.
  void setUserLatLng() async {
    // try {
    //   final currentLocation = await _gpsRepo.getDevicePosition();
    //   state =
    //   print("current user is ${state.toString()}");
    // } catch (e) {
    //   throw Failure(code: "", message: e.toString());
    // }
  }
}
