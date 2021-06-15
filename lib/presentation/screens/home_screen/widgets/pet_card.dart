import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/directions_request_dialog_box.dart';
import 'package:pet_tracker_youtube/states/map_directions_state_notifier.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:pet_tracker_youtube/utils/assets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PetCard extends StatelessWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _BuildCard(
            deviceSize: _deviceSize,
            scaffoldContext: context,
          ),
          const _BuildPetPhoto(),
        ],
      ),
    );
  }
}

class _BuildPetPhoto extends StatelessWidget {
  const _BuildPetPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      top: -40,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            Assets.miniDachsundImg,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 1.0),
            blurRadius: 6.0,
          ),
        ]),
      ),
    );
  }
}

class _BuildCard extends ConsumerWidget {
  const _BuildCard({
    Key? key,
    required this.scaffoldContext,
    required Size deviceSize,
  })  : _deviceSize = deviceSize,
        super(key: key);

  final Size _deviceSize;
  final BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      width: _deviceSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 181,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tarzan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const _BuildLatLngButton(),
              const SizedBox(height: 5),
              const _BuildDIrectionsRowButton(),
              const SizedBox(height: 5),
              Row(
                children: [
                  PetCardButton(
                    text: 'Directions',
                    onPressed: () {
                      showDialog(
                          context: scaffoldContext,
                          builder: (ctx) => const DirectionsRequestDialogBox());
                    },
                    color: const Color(0xFF8ACAC0),
                  ),
                  const SizedBox(width: 5),
                  PetCardButton(
                    text: "Profile",
                    onPressed: () {},
                    color: Colors.orange.shade200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* 
* Custom Buttons For Card
*/

class PetCardButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;

  const PetCardButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => color),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
      onPressed: onPressed,
    );
  }
}

/*
* LatLng Row Btn 
*/

class _BuildLatLngButton extends ConsumerWidget {
  const _BuildLatLngButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final petCoordinate = watch(petCoordinateProvider);
    return InkWell(
      //todo: Not sure if architecturally sound, need to revisit and refactor
      //also need to move into controller class.
      onTap: () async {
        final latestCoord = petCoordinate.data?.value.coordinate;
        log('latest Coord pressed. lates coord: ${latestCoord.toString()}');
        if (latestCoord != null) {
          final newTarget = LatLng(latestCoord.latitude, latestCoord.longitude);
          await context
              .read(homeMapControllerProvider)
              .setCameraToNewPosition(target: newTarget);
        }
      },
      onLongPress: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_pin,
            color: Colors.orange.shade200,
          ),
          petCoordinate.when(
            data: (data) => Text(
                "lat: ${data.coordinate.latitude} long: ${data.coordinate.longitude}"),
            loading: () => SpinKitThreeBounce(color: Colors.orange.shade200),
            error: (err, stck) => Text(err.toString()),
          )
        ],
      ),
    );
  }
}

/*
 * Directions Row Button
 */

class _BuildDIrectionsRowButton extends ConsumerWidget {
  const _BuildDIrectionsRowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final mapDirectionsState = watch(mapDirectionsStateNotifierProvider);

    return InkWell(
      onTap: () {},
      onLongPress: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,

        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Icon(
            Icons.directions_walk,
            color: Color(0xFF8ACAC0),
          ),
          if (mapDirectionsState is MapDirectionsLoaded)
            Text(mapDirectionsState.directions.totalDistance + " away")
          else if (mapDirectionsState is MapDirectionsLoading)
            const Text("Loading...")
          else if (mapDirectionsState is InitialState)
            const Text("Loading")
        ],
      ),
    );
  }
}
