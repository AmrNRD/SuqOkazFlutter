import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.horizontal.buttons.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.settings.button.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.tag.component.dart';
import 'package:suqokaz/utils/app.localization.dart';

import '../../../main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate("settings", defaultText: "settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Root.user != null ? ProfileTagComponent(user: Root.user) : Container(),
            Root.user != null ? HorizontalButtonsComponent() : Container(),
            SettingsButtonComponent(),
          ],
        ),
      ),
    );
  }
}
