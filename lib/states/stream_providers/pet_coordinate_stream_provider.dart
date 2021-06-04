import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';

final petCoordinateProvider =
    StreamProvider.autoDispose<PetCoordinate>((ref) async* {
  final _dbRepo = ref.read(databaseRepoImplProvider);
  final coordStream = _dbRepo.getPetGpsCoordinatesAsBroadcastStream();

  await for (final petCoord in coordStream) {
    yield petCoord;
  }
});
