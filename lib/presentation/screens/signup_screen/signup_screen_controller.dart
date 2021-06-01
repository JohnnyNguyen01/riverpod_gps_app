import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';
import 'package:pet_tracker_youtube/domain/repositories/abstracts/abstracts.dart';
import 'package:pet_tracker_youtube/domain/repositories/repositories.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupScreenController = Provider<SignupScreenController>((ref) {
  final authImpl = ref.read(firebaseAuthProvider);
  return SignupScreenController(authImpl, ref.read);
});

class SignupScreenController {
  final AuthRepository? _authRepository;
  final Function _read;
  SignupScreenController(this._authRepository, this._read);

  ///Verifies the form and then signs up the user to firebase
  void handleSignupButton(
      {required String email,
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
        _authRepository!.signupWithEmailAndPassword(email, password);
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

  ///
  void handleLoginPageButton({required BuildContext context}) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }
}
