import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';

class CategoryBannerHeader extends StatelessWidget {
  CategoryBannerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsetsDirectional.only(
                start: AppDimens.marginDefault16,
                end: AppDimens.marginDefault16,
                top: AppDimens.marginDefault20,
                bottom: AppDimens.marginDefault20),
            width: double.infinity,
            margin: EdgeInsetsDirectional.only(start: AppDimens.marginDefault16, end: AppDimens.marginDefault16,top: 50),
            decoration: BoxDecoration(
              color: AppColors.primaryColors[150],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "UP TO",
                  style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.primaryColor4),
                ),
                Text(
                  "30% DISCOUNT",
                  style: AppTheme.headline1.copyWith(fontWeight: FontWeight.w800, color: AppColors.primaryColor3),
                ),
                Text(
                  "ON MOBILE PHONES",
                  style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.primaryColor4),
                )
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                margin: EdgeInsetsDirectional.only(end: 30),
                child: Image.asset(
                  "assets/images/dummy_phone.png",
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
