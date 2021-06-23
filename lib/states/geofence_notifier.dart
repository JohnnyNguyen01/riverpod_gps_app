import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

/*
 * State Notifier Provider 
 */

final geofenceNotifierProvider =
    StateNotifierProvider<GeofenceNotifier, GeofenceEvent>((ref) {
  return GeofenceNotifier();
});

/*
 * State events 
 */

abstract class GeofenceEvent {
  const GeofenceEvent();
}

class GeofenceInitial extends GeofenceEvent {
  const GeofenceInitial();
}

class GeofenceLoaded extends GeofenceEvent {
  List<PolyGeofence> geofences;
  GeofenceLoaded({required this.geofences});
}

class GeofenceAddingNewFence extends GeofenceEvent {
  const GeofenceAddingNewFence();
}

class GeofenceRemovingFence extends GeofenceEvent {
  PolyGeofence fenceToBeRemoved;
  GeofenceRemovingFence({required this.fenceToBeRemoved});
}

class GeofenceAddLatLngMode extends GeofenceEvent {
  List<LatLng> pointList = [];
  GeofenceAddLatLngMode();
}

/*
 * State Notifier 
 */

class GeofenceNotifier extends StateNotifier<GeofenceEvent> {
  GeofenceNotifier() : super(const GeofenceInitial());

  //add new fence
  Future<void> addNewFence(
      {required String id,
      required List<LatLng> fencePoints,
      required Map<String, dynamic> data}) async {
    state = const GeofenceAddingNewFence();
    final newFence = PolyGeofence(id: id, polygon: fencePoints, data: data);
    state = GeofenceLoaded(geofences: [newFence]);
    log("geofence State: ${state.toString()}");
  }

  //remove a fence

  //remove all fences
  void removeAllFences() {
    state = const GeofenceInitial();
  }

  //set state to adding a new fence in order for user to be access fence select
  //widget
  void showAddFenceUI() {
    state = GeofenceAddLatLngMode();
  }

  void addLatLngForNewFence() {
    state = GeofenceAddLatLngMode();
  }
}
