import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';

class EmptyAddressCard extends StatelessWidget {
  final Function onAdd;

  const EmptyAddressCard({Key key, this.onAdd}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset("assets/icons/no_location.svg"),
          Text(
            AppLocalizations.of(context).translate(
              "no_location_title",
            ),
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: AppColors.customGreyLevels[100],
                ),
          ),
          InkWell(
            onTap: onAdd,
            child: Text(
              AppLocalizations.of(context).translate(
                "no_location_body",
              ),
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: AppColors.primaryColors[50],
                    fontWeight: FontWeight.w300,
                  ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
