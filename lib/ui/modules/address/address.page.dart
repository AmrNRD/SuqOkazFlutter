import 'package:flutter/material.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/utils/app.localization.dart';

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
            canPop: true,
            text: AppLocalizations.of(context)
                .translate("addresses", defaultText: "Addresses")),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text(
            AppLocalizations.of(context)
                .translate("add", defaultText: "Add Address"),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {},
          backgroundColor: Color(0xFFE4E4E4),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AddressCard(
                address: AddressModel(
                    id: 1,
                    address1: "Address",
                    address2: "aaaaaaaaaaaa",
                    city: "Alexandria",
                    company: "Company",
                    country: "Egypt",
                    postCode: "A"),
              ),
              AddressCard(
                address: AddressModel(
                    id: 2,
                    address1: "Address2",
                    address2: "aaaaaaaaaaaa",
                    city: "Cairo",
                    company: "Company",
                    country: "Egypt",
                    postCode: "A"),
              ),
              AddressCard(
                address: AddressModel(
                    id: 3,
                    address1: "Address",
                    address2: "aaaaaaaaaaaa",
                    city: "Jedaah",
                    company: "Company",
                    country: "Egypt",
                    postCode: "A"),
              ),
            ],
          ),
        ));
  }
}
