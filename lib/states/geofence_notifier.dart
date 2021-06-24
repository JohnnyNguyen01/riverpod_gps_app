import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:poly_geofence_service/models/lat_lng.dart' as polyLatLng;

import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

/*
 * State Notifier Provider 
 */

final geofenceNotifierProvider =
    StateNotifierProvider<GeofenceNotifier, GeofenceEvent>((ref) {
  final _dbRepoImpl = ref.read(databaseRepoImplProvider);
  return GeofenceNotifier(dbRepoImplementation: _dbRepoImpl, read: ref.read);
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
  List<polyLatLng.LatLng> pointList = [];
  Set<Circle> pointCircles = {};

  GeofenceAddLatLngMode();
}

class GeofenceError extends GeofenceEvent {
  String message;
  GeofenceError({
    required this.message,
  });
}

/*
 * State Notifier 
 */

class GeofenceNotifier extends StateNotifier<GeofenceEvent> {
  final DatabaseRepository _db;
  final Reader _read;

  GeofenceNotifier(
      {required DatabaseRepository dbRepoImplementation, required Reader read})
      : _db = dbRepoImplementation,
        _read = read,
        super(const GeofenceInitial());

  //add new fence
  Future<void> addNewFence(
      {required String id,
      required List<polyLatLng.LatLng> fencePoints,
      required Map<String, dynamic> data}) async {
    state = const GeofenceAddingNewFence();
    final newFence = PolyGeofence(id: id, polygon: fencePoints, data: data);
    state = GeofenceLoaded(geofences: [newFence]);
    late String uid;
    final userState = _read(userStateProvider);
    if (userState is UserLoggedIn) {
      uid = userState.user.uid!;
    } else {
      state = GeofenceError(message: "Error grabbing User ID");
      state = throw Failure(code: '', message: "No user currently logged in");
    }
    await _db.addNewGeofence(userID: uid, fencePoints: fencePoints);
    log("geofence State: ${state.toString()}");
  }

  //remove a fence

  //remove all fences
  Future<void> removeAllFences() async {
    late String uid;
    final userState = _read(userStateProvider);
    if (userState is UserLoggedIn) {
      uid = userState.user.uid!;
    } else {
      state = GeofenceError(message: "Error grabbing User ID");
      state = throw Failure(code: '', message: "Error grabbing userID");
    }
    await _db.removeGeoFence(userID: uid);
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
