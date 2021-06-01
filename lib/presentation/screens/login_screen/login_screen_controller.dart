import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';

final loginScreenControllerProvider = Provider<LoginScreenController>((ref) {
  return LoginScreenController(read: ref.read);
});

class LoginScreenController {
  final Reader read;

  LoginScreenController({required this.read});

  void handleSignUpNavButton({required BuildContext scaffoldContext}) {
    Navigator.of(scaffoldContext).pushNamed(SignupScreen.routeName);
  }
}
