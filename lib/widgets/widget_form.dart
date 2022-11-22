// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    required this.changeFunc,
    this.controller,
    this.maginTop,
    this.width,
    this.textStyle,
    this.fillColor,
    this.autoFocus,
  }) : super(key: key);

  final String? hint;
  final Function(String) changeFunc;
  final TextEditingController? controller;
  final double? maginTop;
  final double? width;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool? autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: maginTop ?? 0.0),
      width: width,
      child: TextFormField(
        autofocus: autoFocus ?? false,
        style: textStyle,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}
