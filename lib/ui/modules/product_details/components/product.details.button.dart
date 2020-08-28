import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class ProductDetailsTab extends StatelessWidget {
  final String tabName;
  final bool isSelected;
  final Function onTap;
  const ProductDetailsTab(
      {Key key,
      @required this.tabName,
      this.isSelected = false,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            child: Text(
              tabName,
              style: isSelected
                  ? Theme.of(context).textTheme.headline2.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.primaryColors[400],
                      )
                  : Theme.of(context).textTheme.headline2.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.customGreyLevels[100],
                      ),
            ),
            onPressed: onTap,
          ),
          Container(
            color: isSelected ? AppColors.primaryColors[400] : Colors.grey,
            height: isSelected ? 3 : 1,
          ),
        ],
      ),
    );
  }
}
