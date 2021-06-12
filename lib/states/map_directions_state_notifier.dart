import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/states/maps_marker_set.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';
/*
* State Notifier Provider 
*/

final mapDirectionsStateNotifierProvider =
    StateNotifierProvider<MapDirectionsStateNotifier, MapDirectionsStates>(
        (ref) {
  final directionsRepository = ref.read(directionsRepoProvider);
  return MapDirectionsStateNotifier(
      directionsRepository: directionsRepository, read: ref.read);
});

/*
* States 
*/

abstract class MapDirectionsStates {
  const MapDirectionsStates();
}

class InitialState extends MapDirectionsStates {
  InitialState();
}

class MapDirectionsLoading extends MapDirectionsStates {
  const MapDirectionsLoading();
}

class MapDirectionsLoaded extends MapDirectionsStates {
  Directions directions;
  MapDirectionsLoaded({required this.directions});
}

/*
* State Notifier 
*/

///Used to obtain the directions between two of the current points
class MapDirectionsStateNotifier extends StateNotifier<MapDirectionsStates> {
  MapDirectionsStateNotifier(
      {required DirectionsRepository directionsRepository,
      required Reader read})
      : _directionsRepo = directionsRepository,
        _read = read,
        super(InitialState());

  final DirectionsRepository _directionsRepo;
  final Reader _read;

  Future<void> setNewDirections() async {
    try {
      // -- set state to loading --
      state = const MapDirectionsLoading();

      // --create new map directions --
      //set origin to user state origin
      final userState = _read(userStateProvider);
      LatLng origin = const LatLng(0, 0);
      try {
        if (userState is UserLoggedIn) {
          origin = userState.user.location;
        } else {
          throw Failure(code: "", message: "Couldn't load ");
        }
      } on Failure catch (e) {
        throw Failure(code: "", message: e.message);
      }

      //set destination to latest stream provider destination
      //todo: see if there's a better way of doing this in order to fit null safety
      LatLng destination = const LatLng(0, 0);
      final currentMarkeState = _read(mapsMarkerStateNotifierProvider);
      try {
        if (currentMarkeState is MapsMarkerSet) {
          destination = currentMarkeState.markerSet.first.position;
        }
      } catch (e) {
        throw Failure(code: "", message: e.toString());
      }
      final directions = await _directionsRepo.getDirections(
          origin: origin, destination: destination);
      // -- set state to loaded --
      state = MapDirectionsLoaded(directions: directions!);
    } on Failure catch (e) {
      throw Failure(code: "", message: e.message);
    }
  }
}
