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
  }) : super(key: key);

  final String? hint;
  final Function(String) changeFunc;
  final TextEditingController? controller;
  final double? maginTop;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: maginTop ?? 0.0),
      width: width,
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}
