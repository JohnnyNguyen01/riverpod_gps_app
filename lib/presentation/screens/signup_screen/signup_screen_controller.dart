import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

final signupScreenController = Provider<SignupScreenController>((ref) {
  final userStateNotifier = ref.read(userStateProvider.notifier);
  return SignupScreenController(userStateNotifier: userStateNotifier);
});

class SignupScreenController {
  final UserStateNotifier _userStateNotifier;

  SignupScreenController({required UserStateNotifier userStateNotifier})
      : _userStateNotifier = userStateNotifier;

  ///Verifies the form and then signs up the user to firebase
  void handleSignupButton(
      {required String email,
      required String userName,
      required String password,
      required String passwordTwo,
      required BuildContext scaffoldContext,
      required GlobalKey<FormState> formKey}) async {
    //validate email, password
    if (password != passwordTwo) {
      Snackbars.displayErrorSnackbar("Passwords don't match");
      return;
    }
    if (formKey.currentState!.validate())
    //login with firebase
    {
      try {
        await _userStateNotifier.signupUser(
            email: email, name: userName, password: password);
        Navigator.of(scaffoldContext).pushNamed(HomeScreen.routeName);
      } on Failure catch (e) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          Snackbars.displayErrorSnackbar(e.message!),
        );
      }
    } else {
      //show error snackbar for bad form values
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        Snackbars.displayErrorSnackbar("Please check the form"),
      );
    }
  }

  void handleLoginPageButton({required BuildContext context}) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }
}
