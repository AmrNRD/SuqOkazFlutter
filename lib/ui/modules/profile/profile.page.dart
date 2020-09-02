import 'package:flutter/material.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.horizontal.buttons.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.settings.button.component.dart';
import 'package:suqokaz/ui/modules/profile/components/profile.tag.component.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ProfileTagComponent(),
          HorizontalButtonsComponent(),
          SettingsButtonComponent(),
        ],
      ),
    );
  }
}
