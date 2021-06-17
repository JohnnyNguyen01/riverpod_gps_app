import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

/*
 * State events 
 */

abstract class GeofenceEvent {
  const GeofenceEvent();
}

class GeofenceInitial extends GeofenceEvent {
  const GeofenceInitial();
}

class GeofenceLoading extends GeofenceEvent {
  const GeofenceLoading();
}

class GeofenceLoaded extends GeofenceEvent {
  List<PolyGeofence> geofences;
  GeofenceLoaded({required this.geofences});
}

class GeofenceAddingNewFence extends GeofenceEvent {
  PolyGeofence newFence;
  GeofenceAddingNewFence({required this.newFence});
}

class GeofenceRemovingFence extends GeofenceEvent {
  PolyGeofence fenceToBeRemoved;
  GeofenceRemovingFence({required this.fenceToBeRemoved});
}

/*
 * State Notifier 
 */

class GeofenceNotifier extends StateNotifier<GeofenceEvent> {
  GeofenceNotifier() : super(const GeofenceInitial());

  //add new fence

  //remove a fence
}
