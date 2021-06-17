import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';
import 'package:pet_tracker_youtube/states/map_directions_state_notifier.dart';
import 'package:pet_tracker_youtube/states/maps_marker_set.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';
import 'package:poly_geofence_service/models/lat_lng.dart' as PolyLatLng;

// ignore: use_key_in_widget_constructors
class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final userState = watch(userStateProvider);
        final petCoordList = watch(petCoordinateProvider);
        final mapMarkerState = watch(mapsMarkerStateNotifierProvider);
        final homeMapController = watch(homeMapControllerProvider);
        final mapDirectionsState = watch(mapDirectionsStateNotifierProvider);
        final geofenceState = watch(geofenceNotifierProvider);

        //todo: Holy shit fix this, broooooooo. I mean it works but? o_O
        Set<Polygon> _buildPolygons() {
          Set<Polygon> polygons = {};
          if (geofenceState is GeofenceLoaded) {
            for (final fence in geofenceState.geofences) {
              List<LatLng> points = [];
              fence.polygon.forEach((element) =>
                  points.add(LatLng(element.latitude, element.longitude)));
              polygons.add(
                Polygon(
                  polygonId: PolygonId(fence.id),
                  points: points,
                  strokeColor: Colors.orange,
                  strokeWidth: 3,
                  fillColor: Colors.orange.shade200.withOpacity(0.3),
                  visible: true,
                ),
              );
            }
          }
          return polygons;
        }

        return petCoordList.when(
            data: (markers) {
              return GoogleMap(
                mapType: MapType.normal,
                markers: mapMarkerState is MapsMarkerSet
                    ? mapMarkerState.markerSet
                    : {},
                //todo: should maybe point to Tarzan?
                initialCameraPosition: CameraPosition(
                  // tilt: 45.0,
                  target: userState is UserLoggedIn
                      ? userState.user.location
                      : const LatLng(-33.926870, 150.859040),
                  zoom: 14.4746,
                ),
                rotateGesturesEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                polylines: _buildPolyline(mapDirectionsState),
                polygons: _buildPolygons(),
                onTap: (latLng) =>
                    homeMapController.addLatLngToGeofence(latLng),
                onMapCreated: (GoogleMapController controller) {
                  homeMapController.googleMapController.complete(controller);
                },
              );
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (err, stack) {
              return Center(
                child: Text("An Error has occured: ${err.toString()}"),
              );
            });
      },
    );
  }

  Set<Polyline> _buildPolyline(MapDirectionsStates mapDirectionsState) {
    if (mapDirectionsState is MapDirectionsLoaded) {
      return {
        Polyline(
          polylineId: const PolylineId("device_to_petGps"),
          color: const Color(0xFF8ACAC0),
          width: 5,
          patterns: [
            //todo: change so that dotted on walking, solid on driving
            PatternItem.gap(10), PatternItem.dot
          ],
          points: mapDirectionsState.directions.polylinePoints
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
        )
      };
    } else {
      return {};
    }
  }
}
