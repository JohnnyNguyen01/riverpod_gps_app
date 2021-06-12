import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  Directions(
      {required this.bounds,
      required this.polylinePoints,
      required this.totalDistance,
      required this.totalDuration});

  static Directions? fromMap({required Map<String, dynamic> map}) {
    //bounds
    final northEast = LatLng(
        map['bounds']['northeast']['lat'], map['bounds']['northeast']['lng']);
    final southWest = LatLng(
        map['bounds']['southwest']['lat'], map['bounds']['southwest']['lng']);
    final bounds = LatLngBounds(northeast: northEast, southwest: southWest);

    //distance and duration
    String distance = '';
    String duration = '';
    if ((map['legs'] as List).isNotEmpty) {
      final leg = map['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    final polyPoints =
        PolylinePoints().decodePolyline(map['overview_polyline']['points']);

    return Directions(
        bounds: bounds,
        polylinePoints: polyPoints,
        totalDistance: distance,
        totalDuration: duration);
  }

  @override
  String toString() {
    return "directions: bounds: $bounds polyPoints: $polylinePoints totalDistance: $totalDistance totalDuration: $totalDuration ";
  }
}