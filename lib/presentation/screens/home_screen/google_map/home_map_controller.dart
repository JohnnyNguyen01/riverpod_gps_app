import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

/*
 * Controller Provider 
 */

final homeMapControllerProvider = Provider<HomeMapController>((ref) {
  return HomeMapController(read: ref.read);
});

/*
* Controller 
*/
class HomeMapController {
  final Reader _read;
  final Completer<GoogleMapController> _googleMapController = Completer();

  HomeMapController({required Reader read}) : _read = read;

  Completer<GoogleMapController> get googleMapController =>
      _googleMapController;

  ///Animates the Google Map Camera to the specified location,
  ///
  ///`target` - the position we want to animate to.
  Future<void> setCameraToNewPosition({required LatLng target}) async {
    final mapController = await _googleMapController.future;
    final newPosition = CameraPosition(target: target, zoom: 14.476);
    mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  ///Animates the Google Map Camerat to the User's current device location.
  Future<void> setCameraTouserLocation() async {
    final deviceRepo = _read(deviceGpsRepoProvider);
    final devicePosition = await deviceRepo.getDevicePosition();
    final deviceLatLng =
        LatLng(devicePosition.latitude, devicePosition.longitude);
    await setCameraToNewPosition(target: deviceLatLng);
  }

  ///Animate camera for navigation with tilt and what not
  Future<void> setCameraToUserNaviagtion() async {
    try {
      final mapController = await _googleMapController.future;
      final deviceRepo = _read(deviceGpsRepoProvider);
      final devicePosition = await deviceRepo.getDevicePosition();
      final deviceLatLng =
          LatLng(devicePosition.latitude, devicePosition.longitude);
      final newPos = CameraUpdate.newCameraPosition(
        CameraPosition(target: deviceLatLng, tilt: 45, zoom: 20.0, bearing: 90),
      );
      mapController.animateCamera(newPos);
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }
}
