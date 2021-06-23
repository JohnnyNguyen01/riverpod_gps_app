class FirestorePaths {
  static final _singleton = FirestorePaths._internal();

  factory FirestorePaths() {
    return _singleton;
  }

  FirestorePaths._internal();

  final piCoordinatesCollection = "PiCoordinates";
  final usersCollection = "Users";
  final geofencesRootCollection = "Geofences";
}
