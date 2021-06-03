import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';

class DatabaseRepoImplementation implements DatabaseRepository {
  final FirebaseFirestore _db;
  final Reader _read;

  DatabaseRepoImplementation({required Reader read})
      : _db = FirebaseFirestore.instance,
        _read = read;

  @override
  Stream<PetCoordinate> getPetGpsCoordinatesAsBroadcastStream() async* {
    final _petCoordinateStream = _db
        .collection('PiCoordinates')
        .orderBy('date-time')
        .snapshots()
        .asBroadcastStream();
    for (final querySnapshot in await _petCoordinateStream.toList()) {
      for (final doc in querySnapshot.docs) {
        yield PetCoordinate.fromFirestore(doc.data());
      }
    }
  }
}
