import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';

final petCoordinateProvider = StreamProvider.autoDispose((ref) async* {
  final _dbRepo = ref.read(databaseRepoImplProvider);
  final coordStream = _dbRepo.getPetGpsCoordinatesAsBroadcastStream();

  await for (final coordinateList in coordStream) {
    final coordValue = coordinateList.first;
    final dateTime = DateFormat.yMEd().add_jms().format(
          coordValue.dateTime.toDate(),
        );
    yield {
      Marker(
        markerId: const MarkerId("Tarzan"),
        position: LatLng(
            coordValue.coordinate.latitude, coordValue.coordinate.longitude),
        infoWindow: InfoWindow(
          title: 'Tarzan',
          snippet: 'The little guy\'s current location \n As of: $dateTime',
        ),
      )
    };
  }
});
