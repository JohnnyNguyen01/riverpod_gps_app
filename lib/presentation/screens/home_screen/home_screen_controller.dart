import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

final homeScreenControllerProvider = Provider<HomeScreenController>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  return HomeScreenController(gpsRepo: gpsRepo, read: ref.read);
});

class HomeScreenController {
  final DeviceGps _gpsRepo;
  final Reader _read;

  HomeScreenController({required DeviceGps gpsRepo, required Reader read})
      : _gpsRepo = gpsRepo,
        _read = read;

  ///Check and request for Gps access on the device. Run on initState prior to
  ///homescreen startup.
  void requestGpsPermissions() async =>
      await _gpsRepo.requestDevicePermissions();

  void setUserCurrentLocation() =>
      _read(userStateProvider.notifier).setUserLatLng();

  void initFunctions() async {
    requestGpsPermissions();
    setUserCurrentLocation();
  }
}
