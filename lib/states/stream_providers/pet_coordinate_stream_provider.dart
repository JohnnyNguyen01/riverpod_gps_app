import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';

final petCoordinateProvider = StreamProvider.autoDispose((ref) async* {
  final _dbRepo = ref.read(databaseRepoImplProvider);
  final coordStream = _dbRepo.getPetGpsCoordinatesAsBroadcastStream();

  await for (final coordinateList in coordStream) {
    final coordList = coordinateList;

    yield {
      Marker(
        markerId: const MarkerId("Tarzan"),
        position: LatLng(coordList.first.coordinate.latitude,
            coordList.first.coordinate.longitude),
        infoWindow: const InfoWindow(
            title: 'Tarzan', snippet: 'The little guy\'s current location '),
      )
    };
  }
});
