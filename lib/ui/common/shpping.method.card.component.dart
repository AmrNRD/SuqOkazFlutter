import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/radio_button.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';

class ShippingMethodCard extends StatelessWidget {
  final String shippingTitle;
  final String shippingDesc;
  final bool isSelected;
  final Function onPress;

  const ShippingMethodCard(
      {Key key,
      @required this.shippingTitle,
      this.isSelected = false,
      @required this.onPress,
      this.shippingDesc = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimens.marginDefault16),
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.customGreyLevels[200].withOpacity(0.6),
              width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(end: 16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: CustomRadioButton(
                isBox: true,
                value: isSelected,
                onPressed: (_) => onPress(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shippingTitle,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    shippingDesc,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.customGreyLevels[100],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
