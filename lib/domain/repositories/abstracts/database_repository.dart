import 'package:pet_tracker_youtube/domain/models/models.dart';

abstract class DatabaseRepository {
  Stream<PetCoordinate> getPetGpsCoordinatesAsBroadcastStream() async* {}
}
