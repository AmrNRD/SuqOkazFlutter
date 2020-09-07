import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class CustomRadioButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final bool value;
  final bool isBox;

  const CustomRadioButton({
    Key key,
    this.size = 20,
    this.onPressed,
    @required this.value,
    this.isBox = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        onPressed(!value);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: !value ? Colors.white : AppColors.primaryColors[50],
          border: Border.all(
            width: 1.25,
            color: !value
                ? AppColors.customGreyLevels[100]
                : AppColors.primaryColors[50],
          ),
          borderRadius: isBox
              ? BorderRadius.all(
                  Radius.circular(8),
                )
              : null,
          shape: isBox ? BoxShape.rectangle : BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: size - 4,
        ),
      ),
    );
  }
}
