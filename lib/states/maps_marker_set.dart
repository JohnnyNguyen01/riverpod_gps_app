import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/utils/utils.dart';

/*
 * State Notifier Provider 
 */

final mapsMarkerStateNotifierProvider =
    StateNotifierProvider<MapsMarkerStateNotifier, MapsMarkerStates>((ref) {
  return MapsMarkerStateNotifier();
});

/*
* States 
*/

abstract class MapsMarkerStates {
  const MapsMarkerStates();
}

class InitialState extends MapsMarkerStates {
  const InitialState();
}

class MapsMarkerResetting extends MapsMarkerStates {
  const MapsMarkerResetting();
}

class MapsMarkerSet extends MapsMarkerStates {
  final Set<Marker> markerSet;
  const MapsMarkerSet({required this.markerSet});
}

class MapsMarkerError extends MapsMarkerStates {
  final String errorMsg;

  MapsMarkerError({required this.errorMsg});
}

/*
* State Notifier
*/
class MapsMarkerStateNotifier extends StateNotifier<MapsMarkerStates> {
  MapsMarkerStateNotifier() : super(const InitialState());

  Future<void> setMarker({required PetCoordinate latestPetCoordinate}) async {
    //set state to resetting
    state = const MapsMarkerResetting();

    //process and create new marker
    final formattedDateTime = DateFormat.yMEd().add_jms().format(
          latestPetCoordinate.dateTime.toDate(),
        );

    final markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.0),
      Assets.mapMarker,
    );

    final latestMarker = Marker(
      markerId: const MarkerId("Tarzan"),
      position: LatLng(latestPetCoordinate.coordinate.latitude,
          latestPetCoordinate.coordinate.longitude),
      icon: markerIcon,
      infoWindow: InfoWindow(
        title: 'Tarzan',
        snippet:
            'The little guy\'s current location \n As of: $formattedDateTime',
      ),
    );

    //create new marker set, and assign to state
    state = MapsMarkerSet(markerSet: {latestMarker});
  }
}
