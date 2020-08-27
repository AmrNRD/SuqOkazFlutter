import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

import 'components/address.card.component.dart';


class AddressesPage extends StatefulWidget {
  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          text: AppLocalizations.of(context).translate("addresses", defaultText: "Addresses")
        ),
//        floatingActionButton: FloatingActionButton(child:   Expanded(
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              SvgPicture.asset("assets/images/delete_gray_icon.svg",height: screenAwareSize(16, context),width: screenAwareWidth(16, context)),
//              SizedBox(width: AppDimens.marginDefault8),
//              Text(AppLocalizations.of(context).translate("remove",defaultText: "Remove"),style: Theme.of(context).textTheme.headline3.copyWith(color: Color(0xFFB1B1B1))),
//            ],
//          ),
//        ),
//        onPressed: (){},
//
//          isExtended: true,
//        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AddressCard(),
              AddressCard(),
              AddressCard(),
            ],
          ),
        ));
  }
}

