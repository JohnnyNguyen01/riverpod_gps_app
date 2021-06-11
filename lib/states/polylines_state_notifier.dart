import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
/*
* State Notifier Provider 
*/

/*
* States 
*/

abstract class PolylinesStates {
  const PolylinesStates();
}

class InitialState extends PolylinesStates {
  final Set<Polyline> polyLines = {};
  InitialState();
}

/*
* State Notifier 
*/

class PolylinesStateNotiifer extends StateNotifier<PolylinesStates> {
  PolylinesStateNotiifer() : super(InitialState());
}
