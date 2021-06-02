import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

// ignore: use_key_in_widget_constructors
class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // ignore: prefer_const_declarations
  // static final CameraPosition _kGooglePlex = const CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final currentUserState = watch(userStateProvider);
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: currentUserState.location,
            zoom: 14.4746,
          ),
          zoomControlsEnabled: true,
          rotateGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        );
      },
    );
  }
}
