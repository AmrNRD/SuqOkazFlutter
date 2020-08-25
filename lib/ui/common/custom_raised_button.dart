import 'package:flutter/material.dart';

import '../../utils/core.util.dart';
import '../../utils/core.util.dart';
import '../style/app.colors.dart';
import '../style/app.colors.dart';
import '../style/theme.dart';

class CustomRaisedButton extends StatelessWidget {
  final bool isLoading;
  final Color buttonColor;
  final Function onPress;
  final String label;
  final TextStyle style;
  final double customWidth;
  final double customHeight;
  final Color textColor;
  final Color customBorderColor;

  const CustomRaisedButton({
    Key key,
    @required this.isLoading,
    @required this.onPress,
    @required this.label,
    this.style,
    this.buttonColor,
    this.textColor,
    this.customWidth = 18,
    this.customHeight = 18, this.customBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),side: customBorderColor!=null?BorderSide(color: customBorderColor):BorderSide.none),
      padding: EdgeInsets.symmetric(vertical: 14),
      onPressed: isLoading ? () {} : onPress,
      highlightElevation: 0,
      elevation: 0,
      child: isLoading
          ? Container(
              height: screenAwareSize(customHeight, context),
              width: screenAwareWidth(customWidth, context),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Container(
              height: screenAwareSize(customHeight, context),
              width: screenAwareWidth(customWidth, context),
              child: Text(
                label,
                textAlign:TextAlign.center,
                style: style ??
                    Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: textColor ?? Colors.white),
              ),
            ),
      color: buttonColor??AppColors.primaryColor5,
    );
  }
}
