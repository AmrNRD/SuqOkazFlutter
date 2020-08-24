import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';

class CategoryBannerBox extends StatelessWidget {
  CategoryBannerBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColors[150],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: AppDimens.marginDefault16,top: AppDimens.marginDefault16,bottom: AppDimens
                  .marginDefault16),
              child: Text(
                "MOBILE PHONES",
                style: AppTheme.body.copyWith(fontWeight: FontWeight.w800, color: AppColors.primaryColor3,fontSize: 13),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: AppDimens.marginDefault12,top: AppDimens.marginDefault8,bottom: AppDimens
                .marginDefault8),
            child: Image.asset(
              "assets/images/dummy_phone.png",
              fit: BoxFit.contain,
              height: 40,
            ),
          )
        ],
      ),
    );
  }
}
