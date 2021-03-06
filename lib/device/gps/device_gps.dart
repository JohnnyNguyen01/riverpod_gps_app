import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

final deviceGpsRepoProvider = Provider<DeviceGps>((ref) {
  return DeviceGps();
});

class DeviceGps {
  ///Requqest device permission, run at start of app.
  Future<void> requestDevicePermissions() async {
    var permission = await Geolocator.checkPermission();
    log(permission.toString());
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      null;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      permission == LocationPermission.denied
          ? throw Failure(code: "", message: "Permissions were denied")
          : null;
    }
    if (permission == LocationPermission.deniedForever) {
      throw Failure(
          code: "",
          message:
              "Location permissions are permanently denied. We are unabled to request permssion.");
    }
  }

  ///Get the device's current location.
  Future<Position> getDevicePosition() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }

  ///Returns a stream of the current device's position.
  Stream<Position> getCurrentPositionStream() {
    return Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  ///Get the bearing between a starting position and a target positionl.
  Future<double> getBearingBetween(
      {required double startLat,
      required double startLng,
      required double targetLat,
      required double targetLng}) async {
    try {
      return Geolocator.bearingBetween(
          startLat, startLng, targetLat, targetLng);
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }
}
