import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/utils/validators.dart';

class AuthTextFormField extends StatelessWidget {
  final TextEditingController _controller;

  const AuthTextFormField({Key? key, required TextEditingController controller})
      : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      cursorColor: Colors.orange,
      decoration: InputDecoration(
        hintText: 'Email',
        fillColor: Colors.orange.shade200,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      validator: StringValidators.instance.emailValidator,
    );
  }
}
