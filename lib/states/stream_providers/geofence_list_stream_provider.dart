import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';

final geofenceListStreamProvider = StreamProvider.autoDispose((ref) async* {
  final _geofenceState = ref.read(geofenceNotifierProvider);

  if (_geofenceState is GeofenceAddLatLngMode) {
    final pointList = _geofenceState.pointList;
    yield pointList;
  }
});
