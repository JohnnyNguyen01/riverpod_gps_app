import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/presentation/screens/login_screen/login_screen_controller.dart';
import 'package:pet_tracker_youtube/presentation/widgets/widgets.dart';

class LoginForm extends StatefulWidget {
  final LoginScreenController pageController;
  final BuildContext scaffoldContext;
  const LoginForm(
      {required this.pageController, required this.scaffoldContext});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailTextController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextFormField(controller: _emailTextController),
          const SizedBox(height: 15),
          PasswordTextFormField(controller: _passwordController),
          const SizedBox(height: 40),
          _SubmitButton(onPressed: () {})
          // => widget.pageController.handleSignupButton(
          //     email: _emailTextController.text,
          //     password: _emailPassOneController.text,
          //     passwordTwo: _emailPassTwoController.text,
          //     scaffoldContext: widget.scaffoldContext,
          //     formKey: _formKey)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
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
