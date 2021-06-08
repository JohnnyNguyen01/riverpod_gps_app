import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  Future<void> setCameraToNewPosition({required LatLng target}) async {
    final mapController = await _googleMapController.future;
    final newPosition = CameraPosition(target: target, zoom: 14.476);
    mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }
}
