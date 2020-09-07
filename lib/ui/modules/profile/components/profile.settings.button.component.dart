import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app.dart';
import '../../../../utils/app.localization.dart';
import '../../../style/app.colors.dart';

class SettingsButtonComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: AppColors.customGreyLevels[300],
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Text(
            AppLocalizations.of(context).translate(
              "todo",
              defaultText: "Settings",
            ),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Column(
            children: <Widget>[
              buildSettingsButtton(
                "Change Language",
                "Arabic",
                context,
                () {
                  if (AppLocalizations.of(context).currentLanguage ==
                      Locale('ar').toString()) {
                    application.updateLocale('en', context);
                  } else {
                    application.updateLocale('ar', context);
                  }
                },
              ),
              buildSettingsButtton(
                AppLocalizations.of(context).translate("about_us"),
                "",
                context,
                launchToAboutURL,
              ),
              buildSettingsButtton(
                "Log out",
                "",
                context,
                () {
                  Navigator.pushReplacementNamed(context, Constants.authPage);
                },
                hideDivider: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  launchToAboutURL() async {
    const url = 'https://suqokaz.com/en/about/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildSettingsButtton(
      String lableKey, String hintKey, BuildContext context, Function onPress,
      {bool hideDivider = false}) {
    return InkWell(
      onTap: onPress,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate(
                    lableKey,
                    defaultText: lableKey,
                  ),
                  style: Theme.of(context).textTheme.button,
                ),
                Row(
                  children: <Widget>[
                    hintKey != null || hintKey == ""
                        ? Container(
                            margin: EdgeInsetsDirectional.only(end: 8),
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "todo",
                                defaultText: hintKey,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                            ),
                          )
                        : Container(),
                    AppLocalizations.of(context).locale.languageCode == "ar"
                        ? SvgPicture.asset(
                            "assets/icons/backward_icon.svg",
                            width: 10,
                            height: 10,
                          )
                        : SvgPicture.asset(
                            "assets/icons/forward_icon.svg",
                            width: 10,
                            height: 10,
                          ),
                  ],
                )
              ],
            ),
          ),
          hideDivider
              ? Container()
              : Divider(
                  height: 1,
                ),
        ],
      ),
    );
  }
}
