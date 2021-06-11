import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_tracker_youtube/domain/repositories/directions_repo_impl.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/custom_drawer.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/pet_card.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';
import 'google_map/home_map.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  static Route route() => PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read(homeScreenControllerProvider).initFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(children: [
        HomeMap(),
        const PetCard(),
        const _BuildNavDrawerButton(),
        const _BuildCurentPositionButton(),
        const TestBtn()
      ]),
    );
  }
}

/*
* Nav Drawer Icon Button 
*/
class _BuildNavDrawerButton extends StatelessWidget {
  const _BuildNavDrawerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}

/*
 * Current position button 
 */
class _BuildCurentPositionButton extends StatelessWidget {
  const _BuildCurentPositionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      bottom: 200,
      child: Consumer(
        builder: (context, watch, child) => FloatingActionButton.extended(
          onPressed: () async => await context
              .read(homeMapControllerProvider)
              .setCameraTouserLocation(),
          label: const Icon(Icons.my_location),
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFF8ACAC0),
        ),
      ),
    );
  }
}

/*
 * Test Btn 
 * Delete when testing is finished
 */

class TestBtn extends ConsumerWidget {
  const TestBtn({Key? key}) : super();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SafeArea(
      child:
          // ElevatedButton(onPressed: () {}, child: const Text('test distance api')));
          TextButton(
        onPressed: () async {
          final user = watch(userStateProvider);
          final location = user is UserLoggedIn
              ? user.user.location
              : const LatLng(-35.12, 142);
          const pet = LatLng(-33.865143, 151.209900);
          final directions = await context
              .read(directionsRepoProvider)
              .getDirections(origin: location, destination: pet);
        },
        child: const Text('Test distance api'),
      ),
    );
  }
}
