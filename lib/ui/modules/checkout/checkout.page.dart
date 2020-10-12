import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/address/address_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/shipping/shipping_bloc.dart';
import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/repositories/address.repository.dart';
import 'package:suqokaz/data/repositories/shipping_method.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/delayed_animation.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/invoice.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/shpping.method.card.component.dart';
import 'package:suqokaz/ui/modules/address/components/address.card.component.dart';
import 'package:suqokaz/ui/modules/address/components/empty_address.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';
import 'package:suqokaz/utils/snack_bar.dart';

class CheckoutPage extends StatelessWidget {
   final List<ProductItem> productItems;
   final double discount;
   final Coupon coupon;
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CheckoutPage({Key key,@required this.productItems,@required this.discount,@required this.coupon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("checkout"),
        ),
      ),
      body: CheckoutScreen(
        productItems: productItems,
        discount: discount,
        coupon: coupon,
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final List<ProductItem> productItems;
  final double discount;
  final Coupon coupon;
  const CheckoutScreen({
    Key key,
    @required this.productItems, this.discount, this.coupon,
  }) : super(key: key);


  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  AddressBloc addressBloc;

  ShippingBloc shippingBloc;

  @override
  void initState() {
    addressBloc = AddressBloc(
      new AddressDataRepository(Root.appDataBase),
    );
    addressBloc.add(GetAllAddressEvent());

    shippingBloc = ShippingBloc(new ShippingMethodDataRepository());
    shippingBloc.add(GetAllShippingEvent());

    applyShippingMethod();

    super.initState();
  }

  int selectedAddressId = 0;
  String selectedShippingMethod = "0";
  AddressModel _selectedAddressModel;
  ShippingMethod _selectedShippingMethod;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: AppDimens.paddingEdgeCase40,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("choose_location"),
                    style: AppTheme.headline2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColors[200]),
                  ),
                  SizedBox(
                    height: AppDimens.marginDefault16,
                  ),
                  BlocProvider<AddressBloc>(
                    create: (context) => addressBloc,
                    child: BlocListener<AddressBloc, AddressState>(
                      listener: (BuildContext context, AddressState state) {
                        if (state is AddressesLoadedState)
                        {
                          if (state.addresses != null) {
                            setState(() {
                              selectedAddressId = state.addresses[0].id;
                              _selectedAddressModel = state.addresses[0];
                            });
                          }
                        }
                      },
                      child: BlocBuilder<AddressBloc, AddressState>(
                        builder: (context, state) {
                          if (state is AddressesLoadedState) {
                            if (state.addresses.isEmpty ||
                                state.addresses == null) {
                              return EmptyAddressCard(
                                onAdd: () async {
                                  await Navigator.pushNamed(
                                      context, Constants.addAddressScreen);
                                  addressBloc.add(GetAllAddressEvent());
                                },
                              );
                            } else {
                              return Column(
                                children: state.addresses
                                    .map(
                                      (address) => AddressCard(
                                        address: address,
                                        onUpdate: () {
                                          goToUpdateAddressPage(address);
                                        },
                                        onDelete: () async {
                                          BlocProvider.of<AddressBloc>(context)
                                              .add(
                                            DeleteAddressEvent(address.id),
                                          );
                                          addressBloc.add(GetAllAddressEvent());
                                        },
                                        isSelected:
                                            selectedAddressId == address.id,
                                        onTap: () {
                                          setState(() {
                                            selectedAddressId = address.id;
                                            _selectedAddressModel = address;
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimens.marginEdgeCase32,
                  ),
                  /*Text(
                    AppLocalizations.of(context)
                        .translate("please_select_shipping_method"),
                    style: AppTheme.headline2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColors[200]),
                  ),
                  SizedBox(
                    height: AppDimens.marginDefault8,
                  ),
                  Divider(),
                  BlocProvider<ShippingBloc>(
                    create: (context) => shippingBloc,
                    child: BlocBuilder<ShippingBloc, ShippingState>(
                      builder: (context, state) {
                        if (state is ShippingLoadingState)
                          return Container(
                            margin: EdgeInsets.only(top: 28),
                            child: LoadingWidget(),
                          );
                        else if (state is ShippingListLoadedState)
                          return DelayedAnimation(
                            delay: 100,
                            child: Column(
                              children: state.shippingMethods
                                  .map(
                                    (item) => ShippingMethodCard(
                                      isSelected:
                                          selectedShippingMethod == item.id,
                                      shippingTitle: item.title,
                                      shippingDesc: item.description,
                                      onPress: () {
                                        setState(() {
                                          selectedShippingMethod = item.id;
                                          _selectedShippingMethod = item;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        else if (state is ShippingErrorState) {
                          return Center(
                            child: GenericState(
                              imagePath: Constants.imagePath["error"],
                              titleKey: "error_title",
                              bodyKey: state.message,
                              removeButton: true,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),*/
                  SizedBox(
                    height: screenAwareSize(190, context),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.05),
                  blurRadius: 25,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InvoiceComponent(
                  startText: AppLocalizations.of(context).translate("order"),
                  endText: AppLocalizations.of(context).translate(
                    "currency",
                    replacement: BlocProvider.of<CartBloc>(context)
                        .totalPrice
                        .toStringAsFixed(2),
                  ),
                  highlight: true,
                ),
                SizedBox(
                  height: 8,
                ),
                InvoiceComponent(
                  startText: AppLocalizations.of(context).translate("discount"),
                  endText: AppLocalizations.of(context)
                      .translate("currency", replacement: widget.discount.toStringAsFixed(2)),
                  isDiscount: true,
                ),
                SizedBox(
                  height: 8,
                ),
                InvoiceComponent(
                  startText: AppLocalizations.of(context).translate("delivery"),
                  endText: AppLocalizations.of(context)
                      .translate("currency", replacement: calculateShippingLocally(BlocProvider.of<CartBloc>(context)
                      .totalPrice).toString()),
                ),
                SizedBox(
                  height: 8,
                ),
                InvoiceComponent(
                  startText: AppLocalizations.of(context).translate("total"),
                  endText: AppLocalizations.of(context).translate(
                    "currency",
                    replacement:( BlocProvider.of<CartBloc>(context)
                        .totalPrice-(widget.discount??0) + calculateShippingLocally(BlocProvider.of<CartBloc>(context)
                        .totalPrice))
                        .toStringAsFixed(2),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CustomRaisedButton(
                  isLoading: false,
                  label: AppLocalizations.of(context).translate("checkout"),
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
                  onPress: _selectedShippingMethod == null
                      ? () {
                          showScaffoldSnackBar(
                            context: context,
                            scaffoldKey: CheckoutPage.scaffoldKey,
                            backgroundColor: Colors.amber,
                            message: AppLocalizations.of(context).translate(
                                "Please Select valid shipping method",
                                defaultText:
                                "Please Select valid shipping method"),
                          );
                        }
                      : _selectedAddressModel == null
                          ? () {
                              showScaffoldSnackBar(
                                context: context,
                                scaffoldKey: CheckoutPage.scaffoldKey,
                                backgroundColor: Colors.amber,
                                message: AppLocalizations.of(context).translate(
                                    "Please Select or create valid shipping address",
                                    defaultText:
                                        "Please Select or create a valid shipping address"),
                              );
                            }
                          : () => Navigator.pushNamed(
                                context,
                                Constants.paymentPage,
                                arguments: [
                                  _selectedAddressModel,
                                  _selectedShippingMethod,
                                  widget.discount,
                                  widget.coupon
                                ],
                              ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  goToUpdateAddressPage(AddressModel addressModel) async {
    await Navigator.pushNamed(
      context,
      Constants.editAddressScreen,
      arguments: addressModel,
    );
    BlocProvider.of<AddressBloc>(context).add(GetAllAddressEvent());
  }

  void applyShippingMethod(){
    double shippingCost = calculateShippingLocally(BlocProvider.of<CartBloc>(context).totalPrice);
    if(shippingCost > 0){
      _selectedShippingMethod = new ShippingMethod("flat_rate","Flat Rate");
      selectedShippingMethod = "flat_rate";
    }else{
      _selectedShippingMethod = new ShippingMethod("free_shipping","Free Shipping");
      selectedShippingMethod = "free_shipping";
    }
  }
}
