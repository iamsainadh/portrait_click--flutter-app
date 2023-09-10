import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController textController;
  final bool isPassword;
  final String hintText;
  // ignore: prefer_typing_uninitialized_variables
  final textInputType;

  const InputTextField(
      {super.key,
      required this.textController,
      required this.isPassword,
      required this.hintText,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
