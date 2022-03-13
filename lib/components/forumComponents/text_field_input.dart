import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final int maxLines;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.textInputType,
    required this.maxLines
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return TextField(
      controller: textEditingController,
      maxLines: maxLines,
      decoration: const InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
