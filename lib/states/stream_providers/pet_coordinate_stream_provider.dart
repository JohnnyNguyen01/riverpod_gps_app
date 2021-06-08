import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/states/maps_marker_set.dart';

final petCoordinateProvider = StreamProvider.autoDispose((ref) async* {
  final _dbRepo = ref.read(databaseRepoImplProvider);
  final coordStream = _dbRepo.getPetGpsCoordinatesAsBroadcastStream();

  await for (final coordinateList in coordStream) {
    final coordValue = coordinateList.first;
    ref
        .read(mapsMarkerStateNotifierProvider.notifier)
        .setMarker(latestPetCoordinate: coordValue);
    yield coordValue;
  }
});
