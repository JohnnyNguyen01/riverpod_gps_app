import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';

class HomeMapController {
  final Reader _read;

  HomeMapController({required Reader read}) : _read = read;

  // Set<Marker> getLatestPetMarker() {
  //   final petCoordList = _read(petCoordinateProvider);
  //   petCoordList.whenData((value) {
  //     return value;
  //   });
  // }
}
