import 'dart:developer';
import 'dart:convert' as json;

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/models/directions/directions.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/.env.dart';

/*
* Provider 
*/

final directionsRepoProvider =
    Provider<DirectionsRepositoryImplementation>((ref) {
  return DirectionsRepositoryImplementation();
});

/*
* Repository implementation 
*/
class DirectionsRepositoryImplementation implements DirectionsRepository {
  final Dio _dio;

  static const String _baseURL =
      'https://maps.googleapis.com/maps/api/directions/json?';

  DirectionsRepositoryImplementation({Dio? dio}) : _dio = dio ?? Dio();

  //todo: Should return Directions
  @override
  Future<Directions?> getDirections(
      {required LatLng origin, required LatLng destination}) async {
    try {
      final response = await _dio.get(
        _baseURL,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleApiKey
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = response.data['routes'][0];
        // log(responseBody['bounds']['northeast']['lat'].toString());
        Directions? newDirection = Directions.fromMap(map: responseBody);
        log(newDirection!.polylinePoints.toString());
      }
    } catch (e) {
      throw Failure(code: '', message: e.toString());
    }
  }
}
