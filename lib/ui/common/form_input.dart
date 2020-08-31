import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/utils/app.localization.dart';

class FormInput extends StatefulWidget {
  final String translationKey;
  final String defaultValue;
  final bool isLargeInput;
  final bool isRequired;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function onValidation;
  final Function onSave;
  final TextInputType textInputType;

  const FormInput(
      {Key key,
      @required this.translationKey,
      this.isLargeInput = false,
      @required this.onSave,
      this.onValidation,
      this.textInputType = TextInputType.text,
      @required this.focusNode,
      this.nextFocusNode,
      this.isRequired = false,
      this.defaultValue})
      : super(key: key);

  @override
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  TextEditingController textEditingController;
  FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? new FocusNode();

    textEditingController = TextEditingController();
    if (widget.defaultValue != null)
      textEditingController.text = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate(widget.translationKey),
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Color(0xFFF2F2F2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: CustomInputTextField(
            key: Key(widget.translationKey),
            controller: textEditingController,
            focusNode: widget.focusNode,
            validator: widget.onValidation ??
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
            onFieldSubmit: (term) {
              widget.focusNode.unfocus();
              if (widget.nextFocusNode != null)
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
            maxLines: widget.isLargeInput ? 10 : 1,
            minLines: widget.isLargeInput ? 5 : null,
            textInputType: widget.textInputType,
            isCollapes: true,
            onSave: widget.onSave,
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
