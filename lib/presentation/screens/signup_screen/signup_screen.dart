import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/signup_screen/signup_screen_controller.dart';
// ignore: library_prefixes
import 'dart:math' as Math;

import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';

// ignore: use_key_in_widget_constructors
class SignupScreen extends ConsumerWidget {
  static const routeName = "/signupScreen";

  static Route route() => PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        pageBuilder: (_, __, ___) => SignupScreen(),
      );

  static const headingStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
  );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _pageController = watch(signupScreenController);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.stre,
              mainAxisSize: MainAxisSize.max,
              children: [
                Transform.rotate(
                  angle: -Math.pi,
                  child: Image.asset(
                    'assets/images/black-semi-circle.png',
                    width: 40,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Hey,',
                  style: headingStyle,
                ),
                const Text(
                  'Signup Here!',
                  style: headingStyle,
                ),
                _BuildNavToLoginScreen(
                  pageController: _pageController,
                  scaffoldContext: context,
                ),
                const SizedBox(height: 45),
                _BuildForm(
                  pageController: _pageController,
                  scaffoldContext: context,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildNavToLoginScreen extends StatelessWidget {
  final SignupScreenController pageController;
  final BuildContext scaffoldContext;

  const _BuildNavToLoginScreen(
      {Key? key, required this.pageController, required this.scaffoldContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double fontSize = 14.0;
    return Row(
      children: [
        const Text(
          "If you have an account, login ",
          style: TextStyle(fontSize: fontSize),
        ),
        GestureDetector(
          child: const Text(
            'here',
            style: TextStyle(
              color: Colors.orange,
              fontSize: fontSize,
            ),
          ),
          onTap: () =>
              pageController.handleLoginPageButton(context: scaffoldContext),
        ),
      ],
    );
  }
}

//todo: Refactor _BuildForm into separate widget doc
class _BuildForm extends StatefulWidget {
  final SignupScreenController pageController;
  final BuildContext scaffoldContext;
  const _BuildForm(
      {Key? key, required this.pageController, required this.scaffoldContext})
      : super(key: key);
  @override
  __BuildFormState createState() => __BuildFormState();
}

class __BuildFormState extends State<_BuildForm> {
  final _emailTextController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailPassOneController = TextEditingController();
  final _emailPassTwoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextFormField(
            controller: _emailTextController,
            cursorColor: Colors.orange,
            fillColor: Colors.orange.shade200,
            borderSideColor: Colors.orange,
            hintText: 'Email',
          ),
          const SizedBox(height: 15),
          AuthTextFormField(
            controller: _userNameController,
            fillColor: const Color(0xFF8ACAC0),
            cursorColor: Colors.black,
            borderSideColor: Colors.black,
            hintText: 'Name',
          ),
          const SizedBox(height: 15),
          PasswordTextFormField(controller: _emailPassOneController),
          const SizedBox(height: 15),
          PasswordTextFormField(controller: _emailPassTwoController),
          const SizedBox(height: 40),
          _SubmitButton(
              onPressed: () => widget.pageController.handleSignupButton(
                  email: _emailTextController.text,
                  userName: _userNameController.text,
                  password: _emailPassOneController.text,
                  passwordTwo: _emailPassTwoController.text,
                  scaffoldContext: widget.scaffoldContext,
                  formKey: _formKey)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _userNameController.dispose();
    _emailPassOneController.dispose();
    _emailPassTwoController.dispose();
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _SubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton(
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFF8ACAC0),
          ),
        ),
      ),
    );
  }
}
