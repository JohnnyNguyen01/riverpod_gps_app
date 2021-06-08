import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/login_screen/login_screen_controller.dart';

import 'login_form.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends ConsumerWidget {
  static const routeName = '/loginScreen';

  static Route route() => PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginScreen(),
        settings: const RouteSettings(name: routeName),
      );

  static const headingStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
  );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _pageController = watch(loginScreenControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: -math.pi,
                  child: Image.asset(
                    'assets/images/black-semi-circle.png',
                    width: 40,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome back,',
                  style: headingStyle,
                ),
                const Text(
                  'Login here!',
                  style: headingStyle,
                ),
                _BuildNavToSignupScreen(
                  pageController: _pageController,
                  scaffoldContext: context,
                ),
                const SizedBox(height: 40),
                LoginForm(
                  scaffoldContext: context,
                  pageController: _pageController,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildNavToSignupScreen extends StatelessWidget {
  final BuildContext scaffoldContext;
  final LoginScreenController pageController;

  const _BuildNavToSignupScreen(
      {Key? key, required this.scaffoldContext, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Don\'t have an account? Signup '),
        GestureDetector(
          child: const Text(
            'here',
            style: TextStyle(color: Colors.orange),
          ),
          onTap: () => pageController.handleSignUpNavButton(
              scaffoldContext: scaffoldContext),
        )
      ],
    );
  }
}
