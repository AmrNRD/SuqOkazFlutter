import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class CustomInputTextField extends StatelessWidget {
  final Function validator;
  final Function onSave;
  final int inputMaxLength;
  final String hintText;
  final TextInputType textInputType;
  final Image icon;
  final Icon suffixIcon;
  final bool obscure;
  final bool autoFoucs;
  final String label;
  final int maxLines;
  final int minLines;
  final bool isCollapes;
  final TextAlign textAlign;
  final Function onFieldSubmit;
  final Function onChange;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Color borderColor;

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
    this.textInputAction, this.onChange, this.borderColor, this.suffixIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:borderColor!=null? BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: borderColor,
            blurRadius: 4,
          ),
        ],
      ):null,
      child: TextFormField(
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
        onChanged: onChange,
        inputFormatters: [
          LengthLimitingTextInputFormatter(inputMaxLength),
        ],
        textAlign: textAlign,
        validator: (value) {
          return validator(value);
        },
        onSaved: onSave,
        decoration:InputDecoration(
                prefixIcon: icon,
                suffixIcon: suffixIcon,
                hintText: hintText,
                fillColor: Colors.white,
                filled: true,
              )
           ,
      ),
    );
  }
}
