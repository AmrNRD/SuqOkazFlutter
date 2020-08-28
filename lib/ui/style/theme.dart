import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'app.colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme textTheme = TextTheme(
    headline1: headline1,
    headline2: headline2,
    headline3: headline3,
    headline4: headline4,
    headline5: headline5,
    button: button,
    caption: caption,
    bodyText1: body,
    bodyText2: bodySmall,
    subtitle1: input,
    subtitle2: smallText,
  );

  static TextStyle headline1 = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColors[200],
    fontSize: 18,
  );

  static TextStyle headline2 = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColors[200],
    fontSize: 16,
  );

  static TextStyle headline3 = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle headline4 = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle headline5 = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle button = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColors[200],
    fontSize: 16,
  );

  static TextStyle caption = TextStyle(
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle input = TextStyle(
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle body = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle smallText = TextStyle(
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColors[200],
    fontSize: 11,
  );
}
