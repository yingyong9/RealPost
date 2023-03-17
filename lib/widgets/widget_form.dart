// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:realpost/utility/app_constant.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    this.hintStyle,
    this.changeFunc,
    this.controller,
    this.maginTop,
    this.maginBottom,
    this.width,
    this.height,
    this.textStyle,
    this.fillColor,
    this.autoFocus,
    this.textInputFormatters,
    this.textInputType,
    this.labelWidget,
    this.inputBorder,
    this.textAlign,
    this.suffixIcon,
  }) : super(key: key);

  final String? hint;
  final TextStyle? hintStyle;
  final Function(String)? changeFunc;
  final TextEditingController? controller;
  final double? maginTop;
  final double? maginBottom;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool? autoFocus;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputType? textInputType;
  final Widget? labelWidget;
  final InputBorder? inputBorder;
  final TextAlign? textAlign;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: maginTop ?? 0.0, bottom: maginBottom ?? 0.0),
      width: width,
      height: height,
      child: TextFormField(textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        keyboardType: textInputType,
        inputFormatters: textInputFormatters,
        onChanged: changeFunc,
        autofocus: autoFocus ?? false,
        style: textStyle,
        decoration: InputDecoration(
          contentPadding: height != null
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : null,
          label: labelWidget,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          hintText: hint,
          filled: true,
          fillColor: fillColor,
          enabledBorder: inputBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(color: AppConstant.dark)),
          focusedBorder: inputBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(color: AppConstant.dark)),
        ),
      ),
    );
  }
}
