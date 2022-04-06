import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final int maxLines;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.textInputType,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      maxLines: maxLines,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        border: InputBorder.none,
        fillColor: Color(0xfff3B324E),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style:
          (const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
    );
  }
}
