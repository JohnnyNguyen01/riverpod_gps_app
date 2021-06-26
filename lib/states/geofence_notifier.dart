import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g_map;
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
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
  final geofencePlugin = ref.read(geofencePluginProvider);
  return GeofenceNotifier(
      dbRepoImplementation: _dbRepoImpl,
      read: ref.read,
      geofencePlugin: geofencePlugin);
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
  Set<g_map.Circle> pointCircles;
  GeofenceLoaded({required this.geofences, required this.pointCircles});
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
  Set<g_map.Circle> pointCircles = {};
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
  final GeofencePlugin _geofencePlugin;
  final Reader _read;

  GeofenceNotifier(
      {required DatabaseRepository dbRepoImplementation,
      required Reader read,
      required GeofencePlugin geofencePlugin})
      : _db = dbRepoImplementation,
        _read = read,
        _geofencePlugin = geofencePlugin,
        super(const GeofenceInitial());

  //add new fence
  Future<void> addNewFence(
      {required String id,
      required List<polyLatLng.LatLng> fencePoints,
      required Map<String, dynamic> data,
      required Set<g_map.Circle> pointCircles}) async {
    state = const GeofenceAddingNewFence();
    final newFence = PolyGeofence(id: id, polygon: fencePoints, data: data);
    state = GeofenceLoaded(geofences: [newFence], pointCircles: pointCircles);
    late String uid;
    final userState = _read(userStateProvider);
    if (userState is UserLoggedIn) {
      uid = userState.user.uid!;
    } else {
      state = GeofenceError(message: "Error grabbing User ID");
      state = throw Failure(code: '', message: "No user currently logged in");
    }
    await _db.addNewGeofence(userID: uid, fencePoints: fencePoints);
    _geofencePlugin.addPolyGeoFenceToListener(polyGeoFence: newFence);
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
    _geofencePlugin.removeAllFences();
    state = const GeofenceInitial();
  }

  //set state to adding a new fence in order for user to be access fence select
  //widget
  void showAddFenceUI() {
    state = GeofenceAddLatLngMode();
    _read(homeMapControllerProvider).setCameraTouserLocation();
  }

  ///Checks firebase for any instances of the current user's geofences.
  Future<void> setFenceFromDatabase() async {
    //get uid, geofence root collection
    final databaseProvider = _read(databaseRepoImplProvider);
    final userState = _read(userStateProvider);
    late String? uid;
    if (userState is UserLoggedIn) {
      uid = userState.user.uid;
    } else {
      throw Failure(code: "", message: "Error retring uid");
    }
    //check if uid contains any geofences
    final pointsList = await databaseProvider.getGeofence(uid: uid.toString());
    if (pointsList.isEmpty) {
      state = const GeofenceInitial();
      return;
    } else {
      final fence = PolyGeofence(id: "Tarzan", polygon: pointsList, data: {});
      final circleSet = pointsList
          .map(
            (e) => g_map.Circle(
                circleId:
                    g_map.CircleId('lat: ${e.latitude} lon: ${e.longitude}'),
                center: g_map.LatLng(e.latitude, e.longitude),
                radius: 1,
                strokeWidth: 2,
                strokeColor: Colors.orange,
                fillColor: Colors.orange.shade200,
                zIndex: 5),
          )
          .toSet();
      state = GeofenceLoaded(geofences: [fence], pointCircles: circleSet);
    }
    //if yes create fence, if no, return state to initial
  }
}
