import 'dart:convert';
import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_event.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/form.input.dart';

import '../../../../utils/app.localization.dart';
import '../../../../utils/constants.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class LoginScreen extends StatefulWidget {
  final Function goToSignUp;
  final Function goToForgotPassword;

  const LoginScreen({Key key, @required this.goToSignUp, @required this.goToForgotPassword}) : super(key: key);

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
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {
        if (state is UserLoadingState) {
          setState(() {
            isLoading = true;
          });
        }
       else if (state is UserLoadedState) {
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
      child: SingleChildScrollView(
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
                  child: Hero(
                    tag: "Logo",
                    child: SvgPicture.asset("assets/images/colored_logo.svg"),
                  ),
                ),

                SizedBox(height: AppDimens.marginEdgeCase64),

                Text(
                  AppLocalizations.of(context).translate("hello"),
                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
                  child: Text(
                    AppLocalizations.of(context).translate("login_message"),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),

                SizedBox(height: AppDimens.marginEdgeCase24),

                //email
                FormInputField(
                  title: "email",
                  focusNode: _emailFocusNode,
                  onSave: (value) => _authData['email'] = value,
                  isRequired: true,
                ),

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
                      _obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      size: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Align(
                //   alignment: AlignmentDirectional.centerEnd,
                //   child: FlatButton(
                //     onPressed: widget.goToForgotPassword,
                //     padding: EdgeInsets.zero,
                //     child: Text(
                //       AppLocalizations.of(context).translate("forget"),
                //       style: Theme.of(context).textTheme.subtitle1,
                //     ),
                //   ),
                // ),

                SizedBox(height: AppDimens.marginEdgeCase32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: CustomRaisedButton(
                        label: AppLocalizations.of(context).translate("login"),
                        onPress: onLogin,
                        isLoading: isLoading,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomRaisedButton(
                          label: AppLocalizations.of(context).translate("skip"),
                          onPress: onSkip,
                          isLoading: false,
                          buttonColor: Colors.transparent,
                          textColor: AppColors.primaryColor5,
                          customBorderColor: AppColors.primaryColor5),
                    ),
                  ],
                ),

                SizedBox(height: AppDimens.marginEdgeCase32),

                // Center(child: Text(AppLocalizations.of(context).translate("Or"), style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14))),

                // SizedBox(height: AppDimens.marginEdgeCase24),

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
                    onTap: widget.goToSignUp,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: AppLocalizations.of(context).translate("do_you_have_account"),
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context).translate("signup"),
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

  void onLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      BlocProvider.of<UserBloc>(context).add(
        LoginUser(
          email: _authData["email"],
          password: _authData["password"],
          platform: Platform.operatingSystem,
        ),
      );
    }
  }

  void onSkip() {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, Constants.homePage);
  }

  Future<void> initiateAppleLogin() async {
    try {
      if (await AppleSignIn.isAvailable()) {
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            String name;
            String email;
            final String providerType = "Apple";
            final String userID = result.credential.user;
            final String token = result.credential.user;

            if (result.credential.fullName.givenName != null && result.credential.fullName.familyName != null)
              name = result.credential.fullName.givenName + ' ' + result.credential.fullName.familyName;
            else if (result.credential.fullName.givenName != null) name = result.credential.fullName.givenName;

            if (result.credential.email != null) email = result.credential.email.toLowerCase();

            final String profileUrl = "images/profile.png";
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(name, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
              backgroundColor: AppColors.accentColor1,
            ));
//    BlocProvider.of<UserBloc>(context)..add(LoginUserWithProvider(providerType, userID, email, name, token, firebaseToken, profileUrl, platform));
            break;
          case AuthorizationStatus.error:
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Apple Error " + result.error.localizedDescription,
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
              backgroundColor: AppColors.accentColor1,
            ));
            break;
          case AuthorizationStatus.cancelled:
            debugPrint('User cancelled');
            break;
        }
      }
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error has has occurred: " + error.toString(),
            style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.accentColor1,
      ));
    }
  }

  Future<void> initiateGoogleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    try {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
        final String providerType = "Google";
        final String userID = account.id;
        final String token = (await account.authentication).accessToken;
        final String name = account.displayName;
        final String email = account.email;
        final String profileUrl = account.photoUrl;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(profileUrl, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
          backgroundColor: AppColors.accentColor1,
        ));
//        BlocProvider.of<UserBloc>(context)..add(LoginUserWithProvider(providerType, userID, email, name, token, firebaseToken, profileUrl, platform));
      });
      await _googleSignIn.signIn();
    } catch (error) {}
  }

  void initiateFacebookLogin() async {
    try {
      var facebookLogin = FacebookLogin();
      var facebookLoginResult = await facebookLogin.logIn(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Error has has occurred: " + facebookLoginResult.errorMessage,
                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
            backgroundColor: AppColors.accentColor1,
          ));
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.loggedIn:
          final res = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${facebookLoginResult.accessToken.token}');
          final profile = json.decode(res.body);
          final String providerType = "Facebook";
          final String userID = facebookLoginResult.accessToken.userId;
          final String token = facebookLoginResult.accessToken.token;
          final String name = profile['first_name'] ?? '' + profile['last_name'] ?? '';
          final String email = profile['email'] ?? '';
          final String profileUrl = profile['picture']['data']['url'];

//          BlocProvider.of<UserBloc>(context)..add(LoginUserWithProvider(providerType, userID, email, name, token, firebaseToken, profileUrl, platform));
          break;
      }
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error has has occurred: " + error.toString(),
            style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.accentColor1,
      ));
    }
  }
}
