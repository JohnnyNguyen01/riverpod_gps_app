import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

abstract class DatabaseRepository {
  Stream<List<PetCoordinate>> getPetGpsCoordinatesAsBroadcastStream();

  Future<void> addNewUser({required UserModel user}) async {}

  Future<void> addNewGeofence(
      {required List<LatLng> fencePoints, required String userID}) async {}

  Future<void> removeGeoFence({required String userID}) async {}
}
