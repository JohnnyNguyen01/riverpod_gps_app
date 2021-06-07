import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

// ignore: use_key_in_widget_constructors
class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final userState = watch(userStateProvider);
        final petCoordList = watch(petCoordinateProvider);

        return petCoordList.when(
            data: (markers) {
              return GoogleMap(
                mapType: MapType.normal,
                markers: markers,
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
                  _controller.complete(controller);
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

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((value) => value.dispose());
  }
}
