import 'package:flutter/material.dart';

class DirectionsRequestDialogBox extends StatefulWidget {
  const DirectionsRequestDialogBox({Key? key}) : super(key: key);

  @override
  State<DirectionsRequestDialogBox> createState() =>
      _DirectionsRequestDialogBoxState();
}

class _DirectionsRequestDialogBoxState
    extends State<DirectionsRequestDialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("How would you like to reach Tarzan?"),
      content: Column(
        children: [
          //Checkbox for Driving
          CheckboxListTile(
            value: false,
            onChanged: (val) {},
            title: const Text("Driving"),
          ),
          const SizedBox(height: 10),
          //Checkbox for Driving
          CheckboxListTile(
            value: false,
            onChanged: (val) {},
            title: const Text("Walking"),
          ),
        ],
      ),
    );
  }
}
