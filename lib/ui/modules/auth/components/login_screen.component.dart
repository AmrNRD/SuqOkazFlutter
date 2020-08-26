import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/form.input.dart';

import '../../../../utils/app.localization.dart';
import '../../../../utils/app.localization.dart';
import '../../../../utils/app.localization.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class LoginScreen extends StatefulWidget {
  final Function goToSignUp;
  final Function goToForgotPassword;

  const LoginScreen({Key key,@required this.goToSignUp,@required this.goToForgotPassword}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  Map<String, String> _authData = {'phone': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
        margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
                child: Hero(tag: "Logo", child: SvgPicture.asset("assets/images/colored_logo.svg",height: screenAwareSize(32, context),width: screenAwareWidth(108.12, context))),
              ),

              SizedBox(height: AppDimens.marginEdgeCase64),

              Text(AppLocalizations.of(context).translate("hello"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),

              Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
                child: Text(AppLocalizations.of(context).translate("please_enter_your_details"), style: Theme.of(context).textTheme.subtitle1),
              ),

              Padding(
                padding: const EdgeInsets.only(top: AppDimens.marginDefault6),
                child: Text("to sign in", style: Theme.of(context).textTheme.subtitle1),
              ),

              SizedBox(height: AppDimens.marginEdgeCase24),

              //email
              FormInputField(title: "phone_number", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value, isRequired: true),

              //password
              FormInputField(
                title: "password",
                focusNode: _passwordFocusNode,
                onSave: (value) => _authData['password'] = value,
                isRequired: true,
                obscureText: _obscureTextLogin,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                  child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 15.0, color: Colors.grey)
                ),
              ),
              FlatButton(onPressed: widget.goToForgotPassword, child: Text(AppLocalizations.of(context).translate("forget"), style: Theme.of(context).textTheme.subtitle1)),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomRaisedButton(label: AppLocalizations.of(context).translate("sign_in"), onPress: onLogin, isLoading: isLoading, customWidth: 212),
                    CustomRaisedButton(label: AppLocalizations.of(context).translate("skip"), onPress: onSkip, isLoading: isLoading, customWidth: 97, buttonColor: Colors.transparent, textColor: AppColors.primaryColor5, customBorderColor: AppColors.primaryColor5),
                  ]
              ),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Center(child: Text("Or", style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14))),

              SizedBox(height: AppDimens.marginEdgeCase24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 20.0),
                    child: GestureDetector(
                      onTap: initiateFacebookLogin,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                        child: new Icon(FontAwesomeIcons.facebookF, color: Color(0xFF0084ff)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: initiateGoogleLogin,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                        child: new Icon(FontAwesomeIcons.google, color: Color(0xFFdb3236)),
                      ),
                    ),
                  ),
                  Platform.isIOS? Padding(
                    padding: EdgeInsets.only(top: 10.0,left: 20),
                    child: GestureDetector(
                      onTap: initiateAppleLogin,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                        child: new Icon(FontAwesomeIcons.apple, color: Colors.black45),
                      ),
                    ),
                  ):Container(),
                ],
              ),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Center(
                child: InkWell(
                  onTap: widget.goToSignUp,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: AppLocalizations.of(context).translate("do_you_have_account"),
                      style: Theme.of(context).textTheme.subtitle1,
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context).translate("sign_up"),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColors.primaryColor1),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
//                  loginBloc.add(
//                    FireLoginEvent(
//                        username: usernameController.text,
//                        password: passwordController.text),
//                  );
    }
  }

  void onSkip(){
    Navigator.pushReplacementNamed(context, Constants.homePage);
  }



  void initiateAppleLogin() {
  }

  void initiateGoogleLogin() {
  }

  void initiateFacebookLogin() {
  }
}
