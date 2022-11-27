// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realpost/utility/app_constant.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    this.hintStyle,
    required this.changeFunc,
    this.controller,
    this.maginTop,
    this.width,
    this.textStyle,
    this.fillColor,
    this.autoFocus,
    this.textInputFormatters,
    this.textInputType,
  }) : super(key: key);

  final String? hint;
  final TextStyle? hintStyle;
  final Function(String) changeFunc;
  final TextEditingController? controller;
  final double? maginTop;
  final double? width;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool? autoFocus;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: maginTop ?? 0.0),
      width: width,
      child: TextFormField(
        keyboardType: textInputType,
        inputFormatters: textInputFormatters,
        onChanged: changeFunc,
        autofocus: autoFocus ?? false,
        style: textStyle,
        decoration: InputDecoration(
          hintStyle: hintStyle,
          hintText: hint,
          filled: true,
          fillColor: fillColor,
          enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: AppConstant.dark)),
          focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: AppConstant.dark)),
        ),
      ),
    );
  }
}
