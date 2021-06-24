import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/device/device.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen_controller.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/custom_drawer.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/widgets/pet_card.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';
import 'package:pet_tracker_youtube/states/map_directions_state_notifier.dart';
import 'package:pet_tracker_youtube/states/stream_providers/pet_coordinate_stream_provider.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
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
    context.read(geofencePluginProvider).initialisePlugin();
  }

  @override
  Widget build(BuildContext context) {
    return ForegroundTask(
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: _BuildWidgets(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    context.read(geofencePluginProvider).dispose();
  }
}

/*
 * build widgets according to state
 * todo: This is dirty af, should change and refactor 
 */

class _BuildWidgets extends ConsumerWidget {
  _BuildWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final geofenceState = watch(geofenceNotifierProvider);

    return Stack(children: [
      HomeMap(),
      const _BuildNavDrawerButton(),
      geofenceState is GeofenceAddLatLngMode
          ? const GeofenceOptions()
          : const PetCard(),
      const _BuildCurentPositionButton(),
      const DirectionsInfoContainer(),
      /*
       * Test button 
       */
      ElevatedButton(
          onPressed: () async {
            final petLocation = await context.read(petCoordinateProvider.last);
            log(context
                .read(geofencePluginProvider)
                .checkIfPointIsInPolygon(
                    LatLng(petLocation.coordinate.latitude,
                        petLocation.coordinate.longitude),
                    geofenceState is GeofenceLoaded
                        ? geofenceState.geofences.first.polygon
                        : [])
                .toString());
          },
          child: const Text("Test foreground"))
    ]);
  }
}

/*
 * Foreground task widget for GeoFence plugin 
 */
class ForegroundTask extends ConsumerWidget {
  const ForegroundTask({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final geofencePlugin = watch(geofencePluginProvider);
    final geofenceState = watch(geofenceNotifierProvider);

    return WillStartForegroundTask(
      onWillStart: () {
        log('foreground task started');
        // You can add a foreground task start condition.
        return true; //geofencePlugin.polyGeofenceService.isRunningService;
      },
      notificationOptions: const NotificationOptions(
          channelId: 'geofence_service_notification_channel',
          channelName: 'Geofence Service Notification',
          channelDescription:
              'This notification appears when the geofence service is running in the background.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.HIGH),
      notificationTitle: 'Geofence Service is running',
      notificationText: 'Tap to return to the app',
      foregroundTaskOptions: const ForegroundTaskOptions(interval: 2000),
      taskCallback: (dateTime) async {
        if (geofenceState is GeofenceLoaded) {
          //todo: refactor below into controller class
          final latestPetCoordinate = await watch(petCoordinateProvider.last);
          final check = geofencePlugin.checkIfPointIsInPolygon(
              LatLng(latestPetCoordinate.coordinate.latitude,
                  latestPetCoordinate.coordinate.longitude),
              geofenceState.geofences.first.polygon);
          log('foreground checker: $check');
        }
      },
      child: child,
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
 * todo: Complete this and refactor business logic
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

      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Card(
            color: Colors.green.shade400,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_left_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    removeAllHtmlTags(state.steps[0].htmlInstructions),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

/*
 * Geofence Options 
 */
class GeofenceOptions extends ConsumerWidget {
  const GeofenceOptions();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Positioned(
      bottom: 20,
      left: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment:
        children: [
          ElevatedButton(
            child: const Text('Add New Fence'),
            onPressed: () {
              context.read(homeScreenControllerProvider).handleAddNewFenceBtn();
            },
          )
        ],
      ),
    );
  }
}
