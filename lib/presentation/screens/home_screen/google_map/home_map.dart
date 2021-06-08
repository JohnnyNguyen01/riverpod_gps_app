import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/states/maps_marker_set.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

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

        return petCoordList.when(
            data: (markers) {
              return GoogleMap(
                mapType: MapType.normal,
                markers: mapMarkerState is MapsMarkerSet
                    ? mapMarkerState.markerSet
                    : {},
                //todo: should maybe point to Tarzan?
                initialCameraPosition: CameraPosition(
                  target: userState is UserLoggedIn
                      ? userState.user.location
                      : const LatLng(-33.926870, 150.859040),
                  zoom: 14.4746,
                ),
                rotateGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
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
}
