import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app.localization.dart';
import '../../../style/app.dimens.dart';

class HorizontalButtonsComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 34,
        vertical: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildButton(
            "assets/icons/history_icon.svg",
            "Orders",
            context,
            ()=>Navigator.pushNamed(context, Constants.myOrderPage),
          ),
          buildButton(
            "assets/icons/location_icon.svg",
            "Addresses",
            context,
                ()=>Navigator.pushNamed(context, Constants.addressesPage),
          ),
          buildButton(
            "assets/icons/help_icon.svg",
            "terms",
            context,
            launchToTermsURL,
          ),
          buildButton(
            "assets/icons/info_icon.svg",
            "My info",
            context,
                ()=>Navigator.pushNamed(context, Constants.editProfilePage),
          ),
        ],
      ),
    );
  }

  Widget buildButton(
    String imagePath,
    String localKey,
    BuildContext context,
    Function onPress,
  ) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            SvgPicture.asset(
              imagePath,
              height: 50,
              width: 50,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPress,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppDimens.marginDefault16,
        ),
        Text(
          AppLocalizations.of(context).translate(
            localKey,
            defaultText: localKey,
          ),
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }

  launchToTermsURL() async {
    const url = 'https://suqokaz.com/en/terms-and-conditions/';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
}
