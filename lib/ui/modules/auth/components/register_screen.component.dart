import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_event.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/form.input.dart';
import 'package:suqokaz/utils/constants.dart';

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

  Map<String, String> _authData = {'email': '', 'password': '', 'password_confirmation': ''};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
        margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
        child: BlocListener<UserBloc, UserState>(
          listener: (BuildContext context, UserState state) {
            if (state is UserLoadedState) {
              setState(() {
                isLoading = false;
              });
              Navigator.pushReplacementNamed(context, Constants.homePage);
            } else if (state is UserErrorState) {
              setState(() {
                isLoading = false;
              });
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
                  child: Hero(tag: "Logo", child: SvgPicture.asset("assets/images/colored_logo.svg")),
                ),

                SizedBox(height: AppDimens.marginEdgeCase64),

                Text(AppLocalizations.of(context).translate("signup") + "!", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),

                SizedBox(height: AppDimens.marginEdgeCase24),

                //email
                FormInputField(
                    title: "email",
                    focusNode: _emailFocusNode,
                    onSave: (value) => _authData['email'] = value,
                    isRequired: true),

                //password
                FormInputField(
                  title: "password",
                  focusNode: _passwordFocusNode,
                  onSave: (value) => _authData['password'] = value,
                  isRequired: true,
                  obscureText: _obscureTextLogin,
                  suffixIcon: GestureDetector(
                      onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                      child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 15.0, color: Colors.grey)),
                ),

                FormInputField(
                  title: "password_confirmation",
                  focusNode: _passwordFocusNode,
                  onSave: (value) => _authData['password_confirmation'] = value,
                  isRequired: true,
                  obscureText: _obscureTextLogin,
                  suffixIcon: GestureDetector(
                      onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                      child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                          size: 15.0, color: Colors.grey)),
                ),

                SizedBox(height: AppDimens.marginEdgeCase32),

                Center(child: CustomRaisedButton(label: AppLocalizations.of(context).translate("signup"), onPress: onSignUp, isLoading: isLoading)),

                SizedBox(height: AppDimens.marginEdgeCase32),

                // Center(child: Text(AppLocalizations.of(context).translate("or"), style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14))),

                SizedBox(height: AppDimens.marginEdgeCase24),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Padding(
                //       padding: EdgeInsets.only(top: 10.0, right: 20.0),
                //       child: GestureDetector(
                //         onTap: initiateFacebookLogin,
                //         child: Container(
                //           padding: const EdgeInsets.all(15.0),
                //           decoration: new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                //           child: new Icon(FontAwesomeIcons.facebookF, color: Color(0xFF0084ff)),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(top: 10.0),
                //       child: GestureDetector(
                //         onTap: initiateGoogleLogin,
                //         child: Container(
                //           padding: const EdgeInsets.all(15.0),
                //           decoration: new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                //           child: new Icon(FontAwesomeIcons.google, color: Color(0xFFdb3236)),
                //         ),
                //       ),
                //     ),
                //     Platform.isIOS
                //         ? Padding(
                //             padding: EdgeInsets.only(top: 10.0, left: 20),
                //             child: GestureDetector(
                //               onTap: initiateAppleLogin,
                //               child: Container(
                //                 padding: const EdgeInsets.all(15.0),
                //                 decoration:
                //                     new BoxDecoration(shape: BoxShape.circle, color: AppColors.customGreyLevels[300]),
                //                 child: new Icon(FontAwesomeIcons.apple, color: Colors.black45),
                //               ),
                //             ),
                //           )
                //         : Container(),
                //   ],
                // ),

                SizedBox(height: AppDimens.marginEdgeCase32),

                Center(
                  child: InkWell(
                    onTap: widget.goToSignIn,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: AppLocalizations.of(context).translate("already_registered"),
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context).translate("sign_in"),
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
      ),
    );
  }

  void initiateFacebookLogin() {}

  onSignUp() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      BlocProvider.of<UserBloc>(context).add(
        SignUpUser(
          _authData['email'],
          _authData['password'],
          _authData['password_confirmation']
        ),
      );
    }
  }

  void initiateGoogleLogin() {}

  void initiateAppleLogin() {}
}
