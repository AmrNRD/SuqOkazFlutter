import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            () {},
          ),
          buildButton(
            "assets/icons/location_icon.svg",
            "Addresses",
            context,
            () {},
          ),
          buildButton(
            "assets/icons/help_icon.svg",
            "Help",
            context,
            () {},
          ),
          buildButton(
            "assets/icons/info_icon.svg",
            "My info",
            context,
            () {},
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
}
