import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/custom_drawer.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/pet_card.dart';
import 'package:pet_tracker_youtube/states/map_directions_state_notifier.dart';
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
        const DirectionsInfoContainer()
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
 * Directions  
 * todo: Complete this
 */
class DirectionsInfoContainer extends ConsumerWidget {
  const DirectionsInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final directionsState = watch(mapDirectionsStateNotifierProvider);
    if (directionsState is MapDirectionsLoaded) {
      final state = directionsState.directions;
      //parse html string
      String removeAllHtmlTags(String htmlText) {
        RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
        return htmlText.replaceAll(exp, '');
      }

      return Card(
        child: Text(removeAllHtmlTags(state.steps[0].htmlInstructions)),
      );
    } else {
      return Container();
    }
  }
}
