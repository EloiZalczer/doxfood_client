import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final String labelText;

  const PasswordField({super.key, this.controller, this.validator, this.labelText = "Password"});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      obscureText: !_visible,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: widget.labelText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
          icon: Icon(_visible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: widget.validator,
    );
  }
}
