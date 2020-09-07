import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';

import '../../../utils/app.localization.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate(
          "about",
          defaultText: "About",
        ),
        canPop: true,
      ) ,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Text(AppLocalizations.of(context).translate("app_name"),style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).translate("about_text1"),
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context).translate("website"),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).translate("about_text2"),
                  ),
                ]
              ),
            ),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate("about_text3"),style: Theme.of(context).textTheme.subtitle1,textAlign: TextAlign.center,),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate("about_text4"),style: Theme.of(context).textTheme.subtitle1,textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
