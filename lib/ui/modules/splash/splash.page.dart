import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/ui/modules/auth/auth.page.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/constants.dart';

import '../../../utils/constants.dart';
import '../../../utils/core.util.dart';
import '../../../utils/core.util.dart';
import '../../style/app.colors.dart';

class LandingSplashScreen extends StatefulWidget {
  @override
  _LandingSplashScreenState createState() => _LandingSplashScreenState();
}

class _LandingSplashScreenState extends State<LandingSplashScreen> {
  String _route;

  @override
  void initState() {
    startTime();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) async {
        if (state is UserLoaded) {

        } else if (state is UserError) {

        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor5,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: AppColors.primaryColor1,
                  highlightColor: AppColors.primaryColor5,
                  child: SvgPicture.asset(
                    "assets/images/splash_background_pattern.svg",
                    alignment: Alignment.centerRight,
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: Hero(tag:"Logo",child: SvgPicture.asset("assets/images/colored_logo.svg",color: Colors.white,height: screenAwareSize(32, context),width: screenAwareWidth(108.12, context))),
            ),
          ],
        ),
      ),
    );
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      //if user registered
      if (prefs.containsKey('userData')) {
        //if email is verified
        if (prefs.containsKey('verified')) {
          //if user completed the initial setup
          if (prefs.containsKey('logedIn')) {
            //check for opening by notification
                _route = Constants.homePage;

          } else {
            //if user did not completed the initial setup
//            _route = SignInDataPage.routeName;
          }
        } else {
          //if email is not verified
//          _route = VerifyPage.routeName;
        }
      } else {
        //if user not registered
        _route = Constants.authPage;
      }

    Duration _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }


  void navigationPage() {
    if(_route==Constants.authPage)
      Navigator.pushReplacement(context, PageRouteBuilder(transitionDuration: Duration(seconds: 1),pageBuilder:(_,__,___)=>AuthPage(),settings: RouteSettings(name: Constants.authPage)));
      else
        Navigator.of(context).pushReplacementNamed(_route);
  }
}
