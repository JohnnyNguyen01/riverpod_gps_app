import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/utils/validators.dart';

class PasswordTextFormField extends StatelessWidget {
  final TextEditingController _controller;

  const PasswordTextFormField(
      {Key? key, required TextEditingController controller})
      : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        fillColor: Colors.grey.shade300,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      validator: StringValidators.instance.passwordValidator,
    );
  }
}
