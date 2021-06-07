// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
// import 'package:pet_tracker_youtube/states/stream_providers/auth_state_provider.dart';

// class AuthWrapper extends ConsumerWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final authState = watch(authStateChangesProvider);

//      authState.whenData((value) {
//       value == null ? SignupScreen() : HomeScreen();
//     });
//   }
// }
