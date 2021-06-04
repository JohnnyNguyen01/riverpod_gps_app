import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/utils/validators.dart';

class AuthTextFormField extends StatelessWidget {
  final TextEditingController _controller;
  final String hintText;
  final Color fillColor;
  final Color cursorColor;
  final Color borderSideColor;

  const AuthTextFormField(
      {Key? key,
      required TextEditingController controller,
      required this.fillColor,
      required this.hintText,
      required this.cursorColor,
      required this.borderSideColor})
      : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderSideColor),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      validator: hintText == "Email"
          ? StringValidators.instance.emailValidator
          : StringValidators.instance.nameValidator,
    );
  }
}
