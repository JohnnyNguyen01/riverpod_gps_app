import 'package:poly_geofence_service/poly_geofence_service.dart';

class GeofencePlugin {
  static final GeofencePlugin instance = GeofencePlugin._internal();
  factory GeofencePlugin() {
    return GeofencePlugin._internal();
  }
  GeofencePlugin._internal();

  // Create a [PolyGeofenceService] instance and set options.
  final polyGeofenceService = PolyGeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      allowMockLocations: false,
      printDevLog: false);
}

void b() {}
