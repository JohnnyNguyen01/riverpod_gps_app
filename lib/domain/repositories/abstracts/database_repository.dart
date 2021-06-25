import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

abstract class DatabaseRepository {
  Stream<List<PetCoordinate>> getPetGpsCoordinatesAsBroadcastStream();
  Future<void> addNewUser({required UserModel user});
  Future<void> addNewGeofence(
      {required List<LatLng> fencePoints, required String userID});
  Future<void> removeGeoFence({required String userID});
  Future<List<LatLng>> getGeofence({required String uid});
}
