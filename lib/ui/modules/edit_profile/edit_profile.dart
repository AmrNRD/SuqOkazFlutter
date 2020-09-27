import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_event.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/custom_cancel_save.component.dart';
import 'package:suqokaz/ui/common/form_input.dart';
import 'package:suqokaz/ui/modules/edit_profile/components/change_password.model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

import '../../../main.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  FocusNode nameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();

  Map<String, dynamic> _profileData = {
    'name': null,
    'phone': null,
    'email': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate(
          "profile",
          defaultText: "Profile",
        ),
        canPop: true,
      ),
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoadedState) {
              setState(() {
                Root.user=Root.user;
              });
           _scaffoldKey.currentState.showSnackBar(
             SnackBar(
               duration: Duration(seconds: 1),
               backgroundColor: Colors.green,
               content: Text(
                 AppLocalizations.of(context).translate("updated_successfully",defaultText:"updated successfully" ),
                 style: Theme.of(context)
                     .textTheme
                     .headline2
                     .copyWith(color: Colors.white),
               ),
             ),
           );
           Duration _duration = new Duration(seconds: 2);
           Timer(_duration, (){
             Navigator.of(context).pop();
           });

            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: AppDimens.marginDefault16),
                    // Center(
                    //     child: ProfileImage(
                    //   url:
                    //       "https://scontent.fcai21-2.fna.fbcdn.net/v/t1.0-9/31955047_1994386694223060_526103944385003520_o.jpg?_nc_cat=104&_nc_sid=09cbfe&_nc_ohc=D-1rMibe_BUAX_3kObW&_nc_ht=scontent.fcai21-2.fna&oh=ec695c0b8e352cbd4b82191ad95da76b&oe=5F7AD683",
                    // )),
                    SizedBox(height: AppDimens.marginEdgeCase24),
                    Text(
                      AppLocalizations.of(context)
                          .translate("my_personal_information", defaultText: "My Personal Information"),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: AppDimens.marginDefault16),
                    FormInput(
                      translationKey: "name",
                      focusNode: nameFocusNode,
                      nextFocusNode: phoneFocusNode,
                      onSave: (value) => _profileData['name'] = value,
                      isRequired: true,
                      defaultValue: Root.user.name,
                    ),
                    SizedBox(height: AppDimens.marginDefault16),

                    SizedBox(height: AppDimens.marginDefault16),
                    FormInput(
                      translationKey: "email",
                      focusNode: emailFocusNode,
                      onSave: (value) => _profileData['email'] = value,
                      isRequired: true,
                      defaultValue: Root.user.email,
                    ),
                    SizedBox(height: AppDimens.marginDefault16),
                    // RaisedButton(
                    //   onPressed: popUpPasswordModel,
                    //   child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       alignment: Alignment.center,
                    //       margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault14),
                    //       child: Text(
                    //           AppLocalizations.of(context).translate(
                    //             "change_password",
                    //             defaultText: "Change Password",
                    //           ),
                    //           style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14))),
                    // ),
                    SizedBox(height: AppDimens.marginEdgeCase32),
                    CustomCancelSaveComponent(
                      isLoading: isLoading,
                      onCancelPress: () => Navigator.pop(context),
                      onSavePress: onSave,
                    ),
                    SizedBox(height: AppDimens.marginEdgeCase32),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void showChangePasswordModel() {}

  void onSave() {
    BlocProvider.of<UserBloc>(context).add(UpdateUserProfile(UserModel(id: Root.user.id,name:_profileData['name'] ,email: _profileData['email'] )));
  }

  void popUpPasswordModel() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(builder: (context, setState) {
              return ChangePasswordModel();
            }),
          );
        });
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key key,
    @required this.url,
    this.size = 88,
    this.onEdit,
  }) : super(key: key);

  final String url;
  final double size;
  final Function onEdit;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          height: size,
          width: size,
          child: ImageProcessor().customImage(
            context,
            url,
          ),
        ),
        Container(
          height: size,
          width: size,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
            color: Colors.transparent,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(AppDimens.marginDefault8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.customGreyLevels[100],
            ),
            child: Icon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.white,
              size: AppDimens.marginDefault12,
            ),
          ),
        )
      ],
    );
  }
}
