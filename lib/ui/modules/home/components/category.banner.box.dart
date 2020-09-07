import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "MOBILE PHONES",
              style: AppTheme.body.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor3,
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            Image.asset(
              "assets/images/dummy_phone.png",
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
