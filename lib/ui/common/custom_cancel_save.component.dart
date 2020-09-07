import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';

class CustomCancelSaveComponent extends StatelessWidget {
  final Function onCancelPress;
  final Function onSavePress;
  final Color cancelTextColor;
  final Color saveTextColor;
  final Color cancelButtonBorderColor;
  final Color saveButtonColor;
  final bool isLoading;

  const CustomCancelSaveComponent({
    Key key,
    @required this.onCancelPress,
    @required this.onSavePress,
    this.cancelTextColor,
    this.saveTextColor,
    this.cancelButtonBorderColor,
    this.saveButtonColor,
    this.isLoading = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: OutlineButton(
            onPressed: onCancelPress,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            highlightedBorderColor:
                cancelButtonBorderColor ?? AppColors.primaryColors[50],
            borderSide: BorderSide(
              color: Color(0xFFDADADA),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                AppLocalizations.of(context).translate("cancel"),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: CustomRaisedButton(
            label: AppLocalizations.of(context).translate("submit"),
            isLoading: isLoading,
            buttonColor: saveButtonColor ?? AppColors.primaryColors[50],
            onPress: onSavePress,
          ),
        ),
      ],
    );
  }
}
