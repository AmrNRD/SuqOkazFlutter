import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/form.input.dart';

import '../../../../utils/app.localization.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.dimens.dart';

class RestPasswordScreen extends StatefulWidget {
  final Function goToSignIn;

  const RestPasswordScreen({Key key, @required this.goToSignIn})
      : super(key: key);
  @override
  _RestPasswordScreenState createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _emailFocusNode;

  Map<String, String> _authData = {'phone': ''};

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
                    child: SvgPicture.asset("assets/images/colored_logo.svg",
                        height: screenAwareSize(32, context),
                        width: screenAwareWidth(108.12, context))),
              ),

              SizedBox(height: AppDimens.marginEdgeCase64),

              Text("Forgot Password",
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

              CustomRaisedButton(
                  label: AppLocalizations.of(context).translate("send"),
                  onPress: onReset,
                  isLoading: isLoading,
                  customWidth: 212),
              SizedBox(height: 140),

              FlatButton(
                  onPressed: widget.goToSignIn,
                  child: Text(
                      AppLocalizations.of(context).translate("back_to_login"),
                      style: Theme.of(context).textTheme.subtitle1)),
            ],
          ),
        ),
      ),
    );
  }

  void onReset() {}
}
