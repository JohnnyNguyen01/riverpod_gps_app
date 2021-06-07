import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

final loginScreenControllerProvider = Provider<LoginScreenController>((ref) {
  final authRepoImpl = ref.read(firebaseAuthProvider);
  return LoginScreenController(read: ref.read, authRepo: authRepoImpl);
});

class LoginScreenController {
  final Reader _read;
  final AuthRepository _authRepo;

  LoginScreenController(
      {required Reader read, required AuthRepository authRepo})
      : _read = read,
        _authRepo = authRepo;

  void handleSignUpNavButton({required BuildContext scaffoldContext}) {
    Navigator.of(scaffoldContext).pushNamed(SignupScreen.routeName);
  }

  void handleLoginButton({
    required String email,
    required String password,
    required BuildContext scaffoldContext,
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      try {
        await _read(userStateProvider.notifier)
            .loginuser(email: email, password: password, name: "");
        final userState = _read(userStateProvider);
        if (userState is UserLoggedIn) {
          Navigator.of(scaffoldContext).pushNamed(HomeScreen.routeName);
        }
      } on Failure catch (e) {
        ScaffoldMessenger.of(scaffoldContext)
            .showSnackBar(Snackbars.displayErrorSnackbar(e.message!));
      }
    } else {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          Snackbars.displayErrorSnackbar("Please check your login details"));
    }
  }
}
