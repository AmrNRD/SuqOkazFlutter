import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/form.input.dart';

import '../../../../utils/app.localization.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class RegisterScreen extends StatefulWidget {
  final Function goToSignIn;

  const RegisterScreen({Key key, @required this.goToSignIn}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  Map<String, String> _authData = {
    'phone': '',
    'password': '',
    'password_confermation': ''
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
        margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
                child: Hero(
                    tag: "Logo",
                    child: SvgPicture.asset("assets/images/colored_logo.svg")),
              ),

              SizedBox(height: AppDimens.marginEdgeCase64),

              Text(AppLocalizations.of(context).translate("sign_up") + "!",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 25, fontWeight: FontWeight.bold)),

              SizedBox(height: AppDimens.marginEdgeCase24),

              //email
              FormInputField(
                  title: "phone_number",
                  focusNode: _emailFocusNode,
                  onSave: (value) => _authData['phone'] = value,
                  isRequired: true),

              //password
              FormInputField(
                title: "password",
                focusNode: _passwordFocusNode,
                onSave: (value) => _authData['password'] = value,
                isRequired: true,
                obscureText: _obscureTextLogin,
                suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                          _obscureTextLogin = !_obscureTextLogin;
                        }),
                    child: Icon(
                        _obscureTextLogin
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 15.0,
                        color: Colors.grey)),
              ),

              FormInputField(
                title: "password_confirmation",
                focusNode: _passwordFocusNode,
                onSave: (value) => _authData['password_confermation'] = value,
                isRequired: true,
                obscureText: _obscureTextLogin,
                suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                          _obscureTextLogin = !_obscureTextLogin;
                        }),
                    child: Icon(
                        _obscureTextLogin
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 15.0,
                        color: Colors.grey)),
              ),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Center(
                  child: CustomRaisedButton(
                      label: AppLocalizations.of(context).translate("sign_up"),
                      onPress: onSignUp,
                      isLoading: isLoading)),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Center(
                  child: Text(AppLocalizations.of(context).translate("or"),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 14))),

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
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.customGreyLevels[300]),
                        child: new Icon(FontAwesomeIcons.facebookF,
                            color: Color(0xFF0084ff)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: initiateGoogleLogin,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.customGreyLevels[300]),
                        child: new Icon(FontAwesomeIcons.google,
                            color: Color(0xFFdb3236)),
                      ),
                    ),
                  ),
                  Platform.isIOS
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20),
                          child: GestureDetector(
                            onTap: initiateAppleLogin,
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.customGreyLevels[300]),
                              child: new Icon(FontAwesomeIcons.apple,
                                  color: Colors.black45),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),

              SizedBox(height: AppDimens.marginEdgeCase32),

              Center(
                child: InkWell(
                  onTap: widget.goToSignIn,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: AppLocalizations.of(context)
                          .translate("already_registered"),
                      style: Theme.of(context).textTheme.subtitle1,
                      children: [
                        TextSpan(
                          text:
                              AppLocalizations.of(context).translate("sign_in"),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: AppColors.primaryColor1),
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

  void initiateFacebookLogin() {}

  onSignUp() {}

  void initiateGoogleLogin() {}

  void initiateAppleLogin() {}
}
