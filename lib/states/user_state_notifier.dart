import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserSigningIn extends UserState {
  const UserSigningIn();
}

class UserSignedIn extends UserState {
  final User user;
  const UserSignedIn(this.user);
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, User>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  return UserStateNotifier(gpsRepo: gpsRepo);
});

class UserStateNotifier extends StateNotifier<User> {
  final DeviceGps _gpsRepo;

  //todo refactor below
  UserStateNotifier({required DeviceGps gpsRepo})
      : _gpsRepo = gpsRepo,
        super(const User(email: "", userName: "", location: LatLng(0, 0)));

  //todo: utilise loading state as well
  void loginuser({required String email, required String name}) {
    final user =
        User(email: email, userName: name, location: const LatLng(0, 0));
    state = user;
  }

  ///Set the user's location [LatLng] to their current location.
  void setUserLatLng() async {
    try {
      final currentLocation = await _gpsRepo.getDevicePosition();
      state = state.copyWith(
          location:
              LatLng(currentLocation.latitude, currentLocation.longitude));
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }
}
