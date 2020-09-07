import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/bloc/address/address_bloc.dart';
import 'package:suqokaz/data/repositories/address.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/address/components/empty_address.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/snack_bar.dart';

import 'components/address.card.component.dart';

class AddressesPage extends StatefulWidget {
  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  void initState() {
    super.initState();
    addressBloc = AddressBloc(new AddressDataRepository(Root.appDataBase));
    addressBloc.add(GetAllAddressEvent());
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AddressBloc addressBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        canPop: true,
        text: AppLocalizations.of(context)
            .translate("addresses", defaultText: "Addresses"),
      ),
      floatingActionButton: AddAddressCustomButton(
        onPress: goToAddAddressPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: BlocProvider(
          create: (context) => addressBloc,
          child: BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              if (state is AddressDeletedState) {
                showScaffoldSnackBar(
                  context: context,
                  scaffoldKey: scaffoldKey,
                  message: AppLocalizations.of(context)
                      .translate("address_removed_successfully"),
                );
                addressBloc.add(GetAllAddressEvent());
              }
            },
            child: BlocBuilder<AddressBloc, AddressState>(
              builder: (context, state) {
                if (state is AddressesLoadedState) {
                  if (state.addresses.isEmpty || state.addresses == null) {
                    return EmptyAddressCard();
                  } else {
                    return Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: state.addresses
                            .map((e) => AddressCard(
                                  address: e,
                                  onUpdate: () {
                                    goToUpdateAddressPage(e);
                                  },
                                  onDelete: () {
                                    addressBloc.add(DeleteAddressEvent(e.id));
                                  },
                                ))
                            .toList(),
                      ),
                    );
                  }
                }
                return EmptyAddressCard();
              },
            ),
          ),
        ),
      ),
    );
  }

  goToAddAddressPage() async {
    await Navigator.pushNamed(context, Constants.addAddressScreen);
    addressBloc.add(GetAllAddressEvent());
  }

  goToUpdateAddressPage(AddressModel addressModel) async {
    await Navigator.pushNamed(context, Constants.editAddressScreen,
        arguments: addressModel);
    addressBloc.add(GetAllAddressEvent());
  }
}

class AddAddressCustomButton extends StatelessWidget {
  final Function onPress;
  const AddAddressCustomButton({
    Key key,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(24.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 19,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/add_location_icon.svg",
              height: 20,
              width: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              AppLocalizations.of(context)
                  .translate("add", defaultText: "Add Address"),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
