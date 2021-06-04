import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/utils/firestore_paths.dart';

final databaseRepoImplProvider = Provider<DatabaseRepoImplementation>((ref) {
  final authRepo = ref.read(firebaseAuthProvider);
  return DatabaseRepoImplementation(read: ref.read, authRepo: authRepo);
});

class DatabaseRepoImplementation implements DatabaseRepository {
  final FirebaseFirestore _db;
  final AuthRepository _authRepo;
  final Reader _read;

  DatabaseRepoImplementation(
      {required Reader read, required AuthRepository authRepo})
      : _db = FirebaseFirestore.instance,
        _authRepo = authRepo,
        _read = read;

  @override
  Stream<PetCoordinate> getPetGpsCoordinatesAsBroadcastStream() async* {
    try {
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
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }

  @override
  Future<void> addNewUser({required UserModel user}) async {
    try {
      final _firebaseuser = _authRepo.getUser();
      if (_firebaseuser == null) throw Failure(code: "", message: "null user");
      await _db
          .collection(FirestorePaths().usersCollection)
          .doc(_firebaseuser.uid)
          .set(user.toFirestoreMap());
    } catch (e) {
      throw Failure(code: "", message: e.toString());
    }
  }
}
