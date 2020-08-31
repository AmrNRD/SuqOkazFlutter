import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final Function onUpdate;
  final Function onDelete;

  const AddressCard({
    Key key,
    @required this.address,
    @required this.onUpdate,
    @required this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.customGreyLevels[300],
      margin: EdgeInsets.only(bottom: AppDimens.marginDefault16),
      padding: EdgeInsets.all(AppDimens.paddingDefault16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/address_icon.svg",
                      height: screenAwareSize(16, context),
                      width: screenAwareWidth(16, context),
                    ),
                    SizedBox(width: AppDimens.marginDefault8),
                    Text(
                      address.city,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: onUpdate,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/images/edit_gray_icon.svg",
                            height: screenAwareSize(16, context),
                            width: screenAwareWidth(16, context),
                          ),
                          SizedBox(
                            width: AppDimens.marginDefault8,
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate("edit", defaultText: "Edit"),
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      color: Color(0xFFB1B1B1),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 0.5,
                      color: AppColors.customGreyLevels[200],
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    InkWell(
                      onTap: onDelete,
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
                                .copyWith(color: Color(0xFFB1B1B1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            address.address1 +
                ", " +
                address.address2 +
                ", " +
                address.company +
                " | " +
                address.postCode,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
