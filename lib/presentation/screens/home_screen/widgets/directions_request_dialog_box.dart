import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/google_map/home_map_controller.dart';
import 'package:pet_tracker_youtube/states/map_directions_state_notifier.dart';

class DirectionsRequestDialogBox extends StatefulWidget {
  const DirectionsRequestDialogBox({Key? key}) : super(key: key);

  @override
  State<DirectionsRequestDialogBox> createState() =>
      _DirectionsRequestDialogBoxState();
}

class _DirectionsRequestDialogBoxState
    extends State<DirectionsRequestDialogBox> {
  bool drivingSet = false;
  bool walkingSet = false;

  void handleDrivingCheckbox() {
    setState(() {
      drivingSet = true;
      walkingSet = false;
    });
  }

  void handleWalkingCheckbox() {
    setState(() {
      drivingSet = false;
      walkingSet = true;
    });
  }

  handleStartNavigationBtn() async {
    await context
        .read(mapDirectionsStateNotifierProvider.notifier)
        .setNewDirections(travelMode: drivingSet ? "driving" : "walking");
    await context.read(homeMapControllerProvider).setCameraToUserNaviagtion();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("How would you like to reach Tarzan?"),
      content: Consumer(builder: (context, watch, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Checkbox for Driving
            CheckboxListTile(
              value: drivingSet,
              onChanged: (_) => handleDrivingCheckbox(),
              title: const Text("Driving"),
            ),
            const SizedBox(height: 10),
            //Checkbox for Driving
            CheckboxListTile(
              value: walkingSet,
              onChanged: (_) => handleWalkingCheckbox(),
              title: const Text("Walking"),
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () async => await handleStartNavigationBtn(),
          child: const Text('Start Navigation'),
        ),
      ],
    );
  }
}
