import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app.localization.dart';
import '../style/app.dimens.dart';

class FormInputField extends StatefulWidget {
  final String title;
  final String hint;
  final TextInputType textInputType;
  final Function onSave;
  final Function validator;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isRequired;
  final TextInputAction textInputAction;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool obscureText;

  const FormInputField(
      {Key key,
      @required this.title,
      this.hint,
      this.textInputType,
      @required this.onSave,
      this.validator,
      this.textEditingController,
      @required this.focusNode,
      this.nextFocusNode,
      this.textInputAction,
      this.isRequired = false,
      this.obscureText=false,
      this.prefixIcon,
      this.suffixIcon})
      : super(key: key);

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: AppDimens.marginDefault16),
          child: Text(
            AppLocalizations.of(context).translate(widget.title),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12),
          child: TextFormField(
            key: Key(widget.title),
            focusNode: widget.focusNode,
            controller: widget.textEditingController,
            obscureText: widget.obscureText,
            keyboardType: widget.textInputType != null
                ? widget.textInputType
                : TextInputType.text,
            validator: widget.validator ??
                (value) {
                  if (widget.isRequired) {
                    if (value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('invalid_value');
                    }
                    return null;
                  } else
                    return null;
                },
            onSaved: widget.onSave,
            style: Theme.of(context).textTheme.headline3,
            textInputAction:
                widget.textInputAction ?? widget.nextFocusNode != null
                    ? TextInputAction.next
                    : TextInputAction.done,
            onEditingComplete: () {
              widget.focusNode.unfocus();
            },
            onFieldSubmitted: (term) {
              widget.focusNode.unfocus();
              if (widget.nextFocusNode != null)
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              prefixIcon:widget.prefixIcon,
              suffixIcon:widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
