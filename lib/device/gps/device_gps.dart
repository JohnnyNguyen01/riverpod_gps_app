import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final deviceGpsRepoProvider = Provider<DeviceGps>((ref) {
  return DeviceGps();
});

class DeviceGps {
  ///Requqest device permission, run at start of app.
  Future<void> requestDevicePermissions() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      permission == LocationPermission.denied
          ? Future.error("Permissions were denied")
          : null;
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permanently denied. We are unabled to request permssion.");
    }
  }

  ///Get the device's current location.
  Future<Position> getDevicePosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
