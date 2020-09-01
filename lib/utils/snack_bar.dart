import 'package:flutter/material.dart';

showScaffoldSnackBar({@required context,@required GlobalKey<ScaffoldState> scaffoldKey,@required String message,int duration=1,Color color=Colors.white,Color backgroundColor=Colors.green}){
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(color: color),
      ),
    ),
  );
}