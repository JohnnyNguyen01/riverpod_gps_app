import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, User>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  return UserStateNotifier(gpsRepo: gpsRepo);
});

class UserStateNotifier extends StateNotifier<User> {
  final DeviceGps _gpsRepo;

  UserStateNotifier({required DeviceGps gpsRepo})
      : _gpsRepo = gpsRepo,
        super(const User(email: "", userName: "", location: LatLng(0, 0)));

  //todo: utilise loading state as well
  void loginuser({required String email, required String name}) {
    state = User(email: email, userName: name, location: const LatLng(0, 0));
  }

  ///Set the user's location [LatLng] to their current location.
  void setUserLatLng() async {
    try {
      final currentLocation = await _gpsRepo.getDevicePosition();
      state = state.copyWith(
          location:
              LatLng(currentLocation.latitude, currentLocation.longitude));
      print("current user is ${state.toString()}");
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }
}
