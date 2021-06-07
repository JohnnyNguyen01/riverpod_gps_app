import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/states/marker_list_state_notifier.dart';
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
    //todo: fix this shit, it's breaking stuff
    // context.read(markerListStateProvider.notifier).updateLatestPetMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final markerListState = watch(markerListStateProvider);
        final userState = watch(userStateProvider);
        return GoogleMap(
          mapType: MapType.normal,
          markers: markerListState is MarkerSet
              ? markerListState.markerSet
              : <Marker>{},
          //todo: should maybe point to Tarzan?
          initialCameraPosition: CameraPosition(
            target: userState is UserLoggedIn
                ? userState.user.location
                : const LatLng(-33.926870, 150.859040),
            zoom: 14.4746,
          ),
          rotateGesturesEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
