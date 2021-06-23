import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';
import 'package:pet_tracker_youtube/states/geofence_notifier.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

import '../../screens.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final geofenceStateNotifier = watch(geofenceNotifierProvider.notifier);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('PlaceHolder title'),
          ),
          ListTile(
            leading: const Icon(Icons.add_location_alt_outlined),
            title: const Text("Add Geofence"),
            onTap: () {
              geofenceStateNotifier.showAddFenceUI();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  Snackbars.genericSnackbar(
                      text: "Tap on the map to add fence corners.",
                      backgroundColor: Colors.black,
                      duration: 4));
            },
          ),
          ListTile(
            leading: const Icon(Icons.wrong_location_outlined),
            title: const Text('Remove all geofences'),
            onTap: () {
              geofenceStateNotifier.removeAllFences();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  Snackbars.genericSnackbar(
                      text: "All Geofences removed",
                      backgroundColor: Colors.black,
                      duration: 4));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                //todo: move to custom controller class.
                watch(userStateProvider.notifier).logoutUser();
                Navigator.of(context).popAndPushNamed(SignupScreen.routeName);
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
