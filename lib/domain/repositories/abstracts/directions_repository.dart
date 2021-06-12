import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

abstract class DirectionsRepository {
  Future<Directions?> getDirections(
      {required LatLng origin,
      required LatLng destination,
      required String travelMode}) async {}
}
