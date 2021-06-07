import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';

/*
* State Notifier Provider 
*/
final markerListStateProvider =
    StateNotifierProvider<MarkerListNotifier, MarkerListState>((ref) {
  return MarkerListNotifier(read: ref.read);
});

/*
* States
*/

abstract class MarkerListState {
  const MarkerListState();
}

class Initial extends MarkerListState {
  final Set<Marker> markerSet;
  Initial() : markerSet = <Marker>{};
}

class ResettingMarker extends MarkerListState {
  const ResettingMarker();
}

class MarkerSet extends MarkerListState {
  final Set<Marker> markerSet;
  const MarkerSet({required this.markerSet});
}

class MarkerError extends MarkerListState {
  final String? errorMsg;
  const MarkerError({required this.errorMsg});
}

/*
* State Notifier 
*/

class MarkerListNotifier extends StateNotifier<MarkerListState> {
  final Reader _read;
  MarkerListNotifier({required Reader read})
      : _read = read,
        super(Initial());

  Future<void> updateLatestPetMarker() async {
    final petCoordStream = _read(petCoordinateProvider);
    // log('latest petCoord Data: ${petCoordStream.data!.value.toString()}');
    petCoordStream.when(data: (petCoord) {
      Set<Marker> markers = Set<Marker>();
      markers.add(
        Marker(
            markerId: const MarkerId("Tarzan"),
            position: LatLng(
                petCoord.coordinate.latitude, petCoord.coordinate.longitude),
            infoWindow: const InfoWindow(
                title: 'Tarzan',
                snippet: 'The little guy\'s current location ')),
      );
      // log('Marker: ${markers.first.toString()}');
    }, loading: () {
      state = const ResettingMarker();
    }, error: (err, stack) {
      state = MarkerError(errorMsg: err.toString());
    });
  }
}