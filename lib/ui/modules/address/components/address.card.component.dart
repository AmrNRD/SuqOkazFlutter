import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({Key key, @required this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE4E4E4),
      margin: EdgeInsets.all(AppDimens.marginEdgeCase24),
      padding: EdgeInsets.all(AppDimens.paddingDefault16),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset("assets/images/address_icon.svg",
                        height: screenAwareSize(16, context),
                        width: screenAwareWidth(16, context)),
                    SizedBox(width: AppDimens.marginDefault8),
                    Text(address.address1,
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset("assets/images/edit_gray_icon.svg",
                              height: screenAwareSize(16, context),
                              width: screenAwareWidth(16, context)),
                          SizedBox(width: AppDimens.marginDefault8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("edit", defaultText: "Edit"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(color: Color(0xFFB1B1B1))),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Color(0xFFB1B1B1),
                      width: 10,
                      thickness: 2,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset("assets/images/delete_gray_icon.svg",
                              height: screenAwareSize(16, context),
                              width: screenAwareWidth(16, context)),
                          SizedBox(width: AppDimens.marginDefault8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("remove", defaultText: "Remove"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(color: Color(0xFFB1B1B1))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Text(address.city, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}
