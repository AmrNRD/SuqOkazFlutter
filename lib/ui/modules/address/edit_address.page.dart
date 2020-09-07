import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/address/address_bloc.dart';
import 'package:suqokaz/data/repositories/address.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/custom_cancel_save.component.dart';
import 'package:suqokaz/ui/common/form_input.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class EditAddressPage extends StatefulWidget {
  final AddressModel addressModel;

  const EditAddressPage({Key key, @required this.addressModel})
      : super(key: key);
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  AddressBloc addressBloc;
  bool isLoading = false;

  FocusNode streetAddressFocusNode = new FocusNode();
  FocusNode apartmentFocusNode = new FocusNode();
  FocusNode stateCityFocusNode = new FocusNode();
  FocusNode countryFocusNode = new FocusNode();
  FocusNode phoneNumberLabelFocusNode = new FocusNode();
  FocusNode companyHotelFocusNode = new FocusNode();
  FocusNode postCodeFocusNode = new FocusNode();
  FocusNode addInfoFocusNode = new FocusNode();

  Map<String, dynamic> _addressData = {
    'address1': null,
    'address2': null,
    'city': null,
    'country': null,
    'company': null,
    'phone_number': null,
    'company_hotel': null,
    'add_info': null,
  };

  @override
  void initState() {
    addressBloc = AddressBloc(
      new AddressDataRepository(
        Root.appDataBase,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addressBloc,
      child: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is AddressUpdatedState) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          } else if (state is AddressErrorState) {
            setState(() {
              isLoading = false;
            });
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1),
                backgroundColor: Colors.brown,
                content: Text(
                  state.message,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(
            text: AppLocalizations.of(context).translate("edit_address"),
            canPop: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(AppDimens.marginEdgeCase24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FormInput(
                      translationKey: "street_address",
                      focusNode: streetAddressFocusNode,
                      nextFocusNode: apartmentFocusNode,
                      onSave: (value) => _addressData['address1'] = value,
                      isRequired: true,
                      defaultValue: widget.addressModel?.address1,
                    ),
                    FormInput(
                        translationKey: "apartment",
                        focusNode: apartmentFocusNode,
                        nextFocusNode: stateCityFocusNode,
                        onSave: (value) => _addressData['address2'] = value,
                        isRequired: true,
                        defaultValue: widget.addressModel?.address2),
                    FormInput(
                        translationKey: "state_city",
                        focusNode: stateCityFocusNode,
                        nextFocusNode: countryFocusNode,
                        onSave: (value) => _addressData['city'] = value,
                        isRequired: true,
                        defaultValue: widget.addressModel?.city),
                    FormInput(
                        translationKey: "country",
                        focusNode: countryFocusNode,
                        nextFocusNode: companyHotelFocusNode,
                        onSave: (value) => _addressData['country'] = value,
                        isRequired: true,
                        defaultValue: widget.addressModel?.country),
                    FormInput(
                        translationKey: "company_hotel",
                        focusNode: companyHotelFocusNode,
                        nextFocusNode: postCodeFocusNode,
                        onSave: (value) => _addressData['company'] = value,
                        defaultValue: widget.addressModel?.company),
                    FormInput(
                        translationKey: "post_code",
                        focusNode: postCodeFocusNode,
                        nextFocusNode: addInfoFocusNode,
                        onSave: (value) => _addressData['post_code'] = value,
                        isRequired: true,
                        defaultValue: widget.addressModel?.postCode),
                    SizedBox(height: 26),
                    CustomCancelSaveComponent(
                      isLoading: isLoading,
                      onCancelPress: () {
                        Navigator.pop(context);
                      },
                      onSavePress: onSave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSave() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    addressBloc.add(
      EditAddressEvent(
        new AddressModel(
          id: widget.addressModel.id,
          address1: _addressData['address1'],
          address2: _addressData['address2'],
          company: _addressData['company'],
          city: _addressData['city'],
          postCode: _addressData['post_code'],
          country: _addressData['country'],
        ),
      ),
    );
  }
}
