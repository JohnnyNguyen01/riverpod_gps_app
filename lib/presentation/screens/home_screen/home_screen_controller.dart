import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart' as pgs;

final homeScreenControllerProvider = Provider<HomeScreenController>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  return HomeScreenController(gpsRepo: gpsRepo, read: ref.read);
});

class HomeScreenController {
  final DeviceGps _gpsRepo;
  final Reader _read;
  Timer? _timer;

  HomeScreenController({required DeviceGps gpsRepo, required Reader read})
      : _gpsRepo = gpsRepo,
        _read = read;

  ///initialises the timer and checks if Tarzan is within the geofence every
  ///60 seconds.
  void initialiseTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      await checkIfPetInGeofenceAndSendNotification();
    });
    log("Timer initialised");
  }

  ///Check and request for Gps access on the device. Run on initState prior to
  ///homescreen startup.
  void requestGpsPermissions() async =>
      await _gpsRepo.requestDevicePermissions();

  void openNavDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void initFunctions() async {
    requestGpsPermissions();
  }

  void handleAddNewFenceBtn() {
    final geofenceNotifier = _read(geofenceNotifierProvider.notifier);
    final geofenceState = _read(geofenceNotifierProvider);

    if (geofenceState is GeofenceAddLatLngMode) {
      geofenceNotifier.addNewFence(
          id: "Test",
          fencePoints: geofenceState.pointList,
          pointCircles: geofenceState.pointCircles,
          data: {'home': 'test address @ address, NSW, 2817'});
    }
  }

  ///Checks if Tarzan is located within the set geofence, if he isn't, a notifcation
  ///is then sent to the phone.
  Future<void> checkIfPetInGeofenceAndSendNotification() async {
    final notificationController = _read(notifcationPluginProvider);
    final geofencePlugin = _read(geofencePluginProvider);
    final latestPetCoordinate = await _read(petCoordinateProvider.last);
    final geofenceState = _read(geofenceNotifierProvider);

    if (geofenceState is GeofenceInitial ||
        geofenceState is GeofenceAddLatLngMode ||
        geofenceState is GeofenceError) {
      return;
    }

    final vertices = geofenceState is GeofenceLoaded
        ? geofenceState.geofences.first.polygon
        : <pgs.LatLng>[];

    final isInFence = geofencePlugin.checkIfPointIsInPolygon(
        pgs.LatLng(latestPetCoordinate.coordinate.latitude,
            latestPetCoordinate.coordinate.longitude),
        vertices);

    if (!isInFence) {
      await notificationController.scheduleNotificationTest();
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
