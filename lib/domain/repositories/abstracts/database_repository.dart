import 'package:pet_tracker_youtube/domain/models/models.dart';

abstract class DatabaseRepository {
  Stream<List<PetCoordinate>> getPetGpsCoordinatesAsBroadcastStream();

  Future<void> addNewUser({required UserModel user}) async {}

  Future<void> addNewGeofence(
      {required List fencePoints, required String userID}) async {}
}
