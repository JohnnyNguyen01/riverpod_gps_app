import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';

final homeScreenControllerProvider = Provider<HomeScreenController>((ref) {
  final gpsRepo = ref.read(deviceGpsRepoProvider);
  return HomeScreenController(gpsRepo: gpsRepo, read: ref.read);
});

class HomeScreenController {
  final DeviceGps _gpsRepo;
  final Reader _read;

  HomeScreenController({required DeviceGps gpsRepo, required Reader read})
      : _gpsRepo = gpsRepo,
        _read = read;

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
}
