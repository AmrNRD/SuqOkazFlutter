import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/custom_cancel_save.component.dart';
import 'package:suqokaz/ui/common/form_input.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ChangePasswordModel extends StatefulWidget {
  @override
  _ChangePasswordModelState createState() => _ChangePasswordModelState();
}

class _ChangePasswordModelState extends State<ChangePasswordModel> {

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  FocusNode oldPasswordFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmPasswordFocusNode = new FocusNode();

  Map<String, dynamic> _changePasswordData = {
    'old_password': null,
    'password': null,
    'confirm_password': null,
  };


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: AppDimens.paddingDefault16),
            Text(AppLocalizations.of(context).translate("change_password",defaultText: "Change Password"),style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.start,),
            SizedBox(height: AppDimens.marginEdgeCase24),
            FormInput(
              translationKey: "old_password",
              focusNode: oldPasswordFocusNode,
              nextFocusNode: passwordFocusNode,
              onSave: (value) => _changePasswordData['old_password'] = value,
              isRequired: true,
            ),
            SizedBox(height: AppDimens.paddingDefault16),
            FormInput(
              translationKey: "password",
              focusNode: passwordFocusNode,
              nextFocusNode: confirmPasswordFocusNode,
              onSave: (value) => _changePasswordData['password'] = value,
              isRequired: true,
            ),
            SizedBox(height: AppDimens.paddingDefault16),
            FormInput(
              translationKey: "confirm_password",
              focusNode: confirmPasswordFocusNode,
              onSave: (value) => _changePasswordData['confirm_password'] = value,
              isRequired: true,
            ),
            SizedBox(height: AppDimens.marginEdgeCase32),
            CustomCancelSaveComponent(
              isLoading: isLoading,
              onCancelPress: ()=>Navigator.pop(context),
              onSavePress: onSave,
            ),
          ],
        ),
      ),
    );
  }

  void onSave() {
  }
}
