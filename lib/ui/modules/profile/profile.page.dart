import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.horizontal.buttons.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.settings.button.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.tag.component.dart';

import '../../../utils/app.localization.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate(
          "todo",
          defaultText: "Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ProfileTagComponent(),
            HorizontalButtonsComponent(),
            SettingsButtonComponent(),
          ],
        ),
      ),
    );
  }
}
