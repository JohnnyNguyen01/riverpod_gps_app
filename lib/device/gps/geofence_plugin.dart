import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

final geofencePluginProvider = Provider<GeofencePlugin>((ref) {
  return GeofencePlugin(read: ref.read);
});

class GeofencePlugin {
  final Reader _read;

  GeofencePlugin({required Reader read}) : _read = read;

  // Create a [PolyGeofenceService] instance and set options.
  final _polyGeofenceService = PolyGeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      allowMockLocations: false,
      printDevLog: false);

  PolyGeofenceService get polyGeofenceService => _polyGeofenceService;

  ///Add a poly geo fence to the Geofence plugin listener
  void addPolyGeoFenceToListener({required PolyGeofence polyGeoFence}) =>
      _polyGeofenceService.addPolyGeofence(polyGeoFence);

  ///Remove a polygeofence from the Geofence plugin listener
  void removePolyGeoFenceFromListener({required PolyGeofence polyGeofence}) =>
      _polyGeofenceService.removePolyGeofence(polyGeofence);

  ///Remove all polygeofences
  void removeAllFences() => _polyGeofenceService.clearPolyGeofenceList();

  ///initialise the plugin in home_map.dart
  void initialisePlugin() async {
    _polyGeofenceService
        .addPolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
    _polyGeofenceService.addPositionChangeListener(_onPositionChanged);
    _polyGeofenceService.addLocationServiceStatusChangeListener(
        _onLocationServiceStatusChanged);
    _polyGeofenceService.addStreamErrorListener(_onError);
    await _polyGeofenceService.start().catchError(_onError);
  }

  // This function is to be called when the geofence status is changed.
  Future<void> _onPolyGeofenceStatusChanged(PolyGeofence polyGeofence,
      PolyGeofenceStatus polyGeofenceStatus, Position position) async {
    log('geofence: ${polyGeofence.toJson()}');
    log('position: ${position.toJson()}');
    log('status: ${polyGeofenceStatus.toString()}');
  }

// This function is to be called when the position has changed.
  void _onPositionChanged(Position position) {
    // log('position: ${position.toJson()}');
    // log("position changed called");
  }

// This function is to be called when a location service status change occurs
// since the service was started.
  void _onLocationServiceStatusChanged(bool status) {
    log('location service status: $status');
  }

// This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      log('Undefined error: $error');
      return;
    }

    log('ErrorCode: $errorCode');
  }

  ///Dispose of the service and unregister listeners. Use when app is closed.
  void dispose() {
    _polyGeofenceService
        .removePolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
    _polyGeofenceService.removePositionChangeListener(_onPositionChanged);
    _polyGeofenceService.removeLocationServiceStatusChangeListener(
        _onLocationServiceStatusChanged);
    _polyGeofenceService.removeStreamErrorListener(_onError);
    _polyGeofenceService.stop();
  }

  ///Checks if a point is contianed within a polygon.
  bool checkIfPointIsInPolygon(LatLng point, List<LatLng> vertices) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (_rayCastIntersect(point, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool _rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }
}
