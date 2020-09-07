import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputTextField extends StatelessWidget {
  final Function validator;
  final Function onSave;
  final int inputMaxLength;
  final String hintText;
  final TextInputType textInputType;
  final Image icon;
  final bool obscure;
  final bool autoFoucs;
  final String label;
  final int maxLines;
  final int minLines;
  final bool isCollapes;
  final TextAlign textAlign;
  final Function onFieldSubmit;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;

  const CustomInputTextField({
    Key key,
    @required this.validator,
    this.inputMaxLength,
    this.hintText,
    this.textInputType = TextInputType.text,
    this.obscure = false,
    this.autoFoucs = false,
    this.onSave,
    this.icon,
    this.label,
    this.maxLines = 1,
    this.minLines = 1,
    this.isCollapes = false,
    this.textAlign = TextAlign.start,
    this.controller,
    this.onFieldSubmit,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmit,
      textInputAction: textInputAction ?? TextInputAction.next,
      controller: controller ?? TextEditingController(),
      style: Theme.of(context).textTheme.subtitle1,
      maxLines: maxLines,
      autofocus: autoFoucs,
      minLines: minLines,
      obscureText: obscure,
      keyboardType: textInputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(inputMaxLength),
      ],
      textAlign: textAlign,
      validator: (value) {
        return validator(value);
      },
      onSaved: onSave,
      decoration: isCollapes
          ? InputDecoration(
              prefixIcon: icon,
              hintText: hintText,
              fillColor: Colors.white,
              filled: true,
            )
          : InputDecoration(
              prefixIcon: icon,
              hintText: hintText,
              labelText: label,
            ),
    );
  }
}
