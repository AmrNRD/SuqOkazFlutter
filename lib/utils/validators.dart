import 'dart:io';

import 'package:flutter/material.dart';

import 'app.localization.dart';

class Validator {
  static const _vodafone = "010";
  static const _orange = "012";
  static const _etisalat = "011";
  static const _we = "015";
  static const _numberLength = 11;
  static const _countryCode1 = "002";
  static const _countryCode2 = "+2";
  static const _emailRegEx =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  var _password;
  var _email;
  var field;

  final BuildContext context;

  Validator(this.context) {
    if (AppLocalizations.of(context).currentLanguage == "ar") {
      field = AppLocalizations.of(context).translate("field");
    } else {
      field = "";
    }
  }

  isConnectedToNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  isEmail(String value) {
    bool check = RegExp(_emailRegEx).hasMatch(value);
    if (check) {
      _email = value;
      return null;
    } else {
      return AppLocalizations.of(context).translate("log_in_error_email");
    }
  }

  bool isEmailBoolCheck(String value) {
    bool check = RegExp(_emailRegEx).hasMatch(value);
    return check;
  }

  isReEmail(String value) {
    if (value == null || value.length == 0) {
      return AppLocalizations.of(context).translate("register_reemail_error");
    } else {
      if (_email == value) {
        return null;
      } else {
        return AppLocalizations.of(context)
            .translate("register_reemail_mismatch");
      }
    }
  }

  isValidPassword(value) {
    if (value == null || value.length == 0) {
      return AppLocalizations.of(context).translate("password_error_empty");
    } else {
      _password = value;
      return null;
    }
  }

  isVaildRePassword(value) {
    if (value == null || value.length == 0) {
      return AppLocalizations.of(context).translate("repassword_error_empty");
    } else {
      if (_password == value) {
        return null;
      } else {
        return AppLocalizations.of(context).translate("repassword_mismatch");
      }
    }
  }

  isEmpty(String value, String type) {
    if (value == null || value.length == 0) {
      return "$field $type ${AppLocalizations.of(context).translate("missing_data")}";
    }
    return null;
  }

  isPhoneNumber(String number) {
    if (number.isNotEmpty) {
      var countryId1 = number.substring(0, 3);
      var countryId2 = number.substring(0, 2);
      if (countryId1 == _countryCode1) {
        number = number.substring(3);
      } else if (countryId2 == _countryCode2) {
        number = number.substring(2);
      }
      var carrierId = number.substring(0, 3);
      if (carrierId == _vodafone ||
          carrierId == _orange ||
          carrierId == _etisalat ||
          carrierId == _we) {
        if (number.length == _numberLength) {
          return null;
        } else {
          return AppLocalizations.of(context).translate("phone_error1");
        }
      } else {
        return AppLocalizations.of(context).translate("phone_error2");
      }
    } else {
      return AppLocalizations.of(context).translate("phone_error3");
    }
  }
}
