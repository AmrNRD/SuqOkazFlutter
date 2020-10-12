import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/orders/orders_bloc.dart';
import 'package:suqokaz/bloc/payment_method/payment_method_bloc.dart';
import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/payment_method_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/repositories/payment_method.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/ui/common/invoice.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/radio_button.dart';
import 'package:suqokaz/ui/modules/address/components/address.card.component.dart';
import 'package:suqokaz/ui/modules/payment/payment_webview.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';
import 'package:suqokaz/utils/snack_bar.dart';

class PaymentPage extends StatefulWidget {
  final AddressModel addressModel;
  final ShippingMethod shippingMethod;
  final double discount;
  final Coupon coupon;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  PaymentPage(
      {Key key, @required this.addressModel, @required this.shippingMethod, this.discount, this.coupon})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod selectedPaymentMethod;
  String selectedPaymentMethodId;
  bool isLoading=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map paymentInfo={};
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode nameFocusNode = new FocusNode();
  FocusNode numberFocusNode = new FocusNode();
  FocusNode monthFocusNode = new FocusNode();
  FocusNode yearFocusNode = new FocusNode();
  FocusNode cvcFocusNode = new FocusNode();

  PaymentMethodBloc _paymentBloc;
  @override
  void initState() {

    super.initState();
    _paymentBloc = new PaymentMethodBloc(new PaymentMethodDataRepository());
    _paymentBloc.add(GetAllPaymentMethodEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        canPop: true,
        text: AppLocalizations.of(context).translate("payment"),
      ),
      body: BlocListener<OrdersBloc,OrdersState>(
        listener: (context,state) async {
          if(state is OrdersLoadingState){
            setState(() {
              isLoading=true;
            });
          }
          if(state is OrderLoadedState){
            if(selectedPaymentMethodId == "cod"){
              setState(() {
                isLoading=false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(
                        child: GenericState(
                          imagePath: Constants.imagePath["delivery_success"],
                          titleKey: AppLocalizations.of(context).translate("congrat"),
                          bodyKey: AppLocalizations.of(context).translate("congrat_body"),
                          buttonKey: AppLocalizations.of(context).translate("my_orders"),
                          toOrderScreen: true,
                        ),
                      ),
                    ),
                  ),
                  ModalRoute.withName(Constants.homePage)
              );
            }else{
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                  content: Text(
                    AppLocalizations.of(context).translate("please_wait"),
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                  ),
                ),
              );
              BlocProvider.of<OrdersBloc>(context).add(CreatePayment(
                  orderId:state.order.id,
                  amount:BlocProvider.of<CartBloc>(context).totalPrice-(widget.discount??0) + calculateShippingLocally(BlocProvider.of<CartBloc>(context).totalPrice),
                  name: paymentInfo['name'],
                  number: paymentInfo['number'],
                  month: int.tryParse(paymentInfo['month'].toString()),
                  year: int.tryParse(paymentInfo['year'].toString()),
                  cvc: int.tryParse(paymentInfo['cvc'].toString())));
            }
          }else if(state is PaymentSuccessfulState){
            BlocProvider.of<OrdersBloc>(context).add(SetOrderPayed(orderId:state.orderId));
          }else if(state is SetPayedSuccessfullyState){
            setState(() {
              isLoading=false;
            });
            BlocProvider.of<CartBloc>(context).add(CheckoutCartEvent());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: GenericState(
                        imagePath: Constants.imagePath["delivery_success"],
                        titleKey: AppLocalizations.of(context).translate("congrat"),
                        bodyKey: AppLocalizations.of(context).translate("congrat_body"),
                        buttonKey: AppLocalizations.of(context).translate("my_orders"),
                        toOrderScreen: true,
                      ),
                    ),
                  ),
                ),
                ModalRoute.withName(Constants.homePage)
            );
          }else if(state is OrderUrlLoadedState){
            print('--------------------------------------');
            print(state.url);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
                content: Text(
                  AppLocalizations.of(context).translate("please_wait"),
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                ),
              ),
            );
            Timer(Duration(seconds: 5), () {
              BlocProvider.of<CartBloc>(context).add(CheckoutCartEvent());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentWebview(
                              url: state.url,
                              onFinish: (number) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      body: Center(
                                        child: GenericState(
                                          imagePath: Constants.imagePath["delivery_success"],
                                          titleKey: AppLocalizations.of(context).translate("congrat"),
                                          bodyKey: AppLocalizations.of(context).translate("congrat_body"),
                                          buttonKey: AppLocalizations.of(context).translate("my_orders"),
                                          onPress: (){
                                            Navigator.pushNamedAndRemoveUntil(context, Constants.homePage, (route) => false);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                );
                              })),
                  ModalRoute.withName(Constants.homePage)
              );
            });

          }else if(state is OrdersErrorState){
            setState(() {
              isLoading=false;
            });
            showScaffoldSnackBar(context: context, scaffoldKey: _scaffoldKey, message:state.message);
          }
          },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      Text(
                        AppLocalizations.of(context).translate("location"),
                        style: AppTheme.headline2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColors[200]),
                      ),
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      // ignore: missing_required_param
                      AddressCard(
                        address: widget.addressModel,
                        removeUtilButtons: true,
                      ),
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("delivery_details"),
                        style: AppTheme.headline2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColors[200],
                        ),
                      ),
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: AppDimens.marginDefault16),
                        padding: EdgeInsets.all(AppDimens.paddingDefault16),
                        decoration: BoxDecoration(
                          color: AppColors.customGreyLevels[300],
                          border: Border.all(
                            color: AppColors.customGreyLevels[300],
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(widget.shippingMethod.title),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      Text(
                        AppLocalizations.of(context).translate("payment_small"),
                        style: AppTheme.headline2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColors[200],
                        ),
                      ),
                      SizedBox(
                        height: AppDimens.marginDefault16,
                      ),
                      PaymentMethodComponent(
                        paymentBloc: _paymentBloc,
                        selectedPaymentMethodId: selectedPaymentMethodId,
                        selectedPaymentMethod: selectedPaymentMethod,
                        onPaymentMethodChange: onPaymentMethodChanged,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                           CustomInputTextField(
                             validator: (String value) {
                               if (value.isEmpty) {
                                 return AppLocalizations.of(context).translate('invalid_value');
                               }else if(value.split(" ").length!=2){
                                 return AppLocalizations.of(context).translate('enter_last_name');
                               }
                             },
                             focusNode: nameFocusNode,
                             controller: widget.nameController,
                             onSave: (value) => paymentInfo['name'] = value,
                             textInputType: TextInputType.text,
                             hintText: AppLocalizations.of(context)
                                 .translate("card_holder"),
                           ),
                           SizedBox(
                             height: 14,
                           ),
                           CustomInputTextField(
                             validator:  (input) {
                               if (input.isEmpty) {
                                 return AppLocalizations.of(context)
                                     .translate('invalid_value');
                               }


                               if (input.length < 8) { // No need to even proceed with the validation if it's less than 8 characters
                                 return AppLocalizations.of(context)
                                     .translate('invalid_value');
                               }

                               int sum = 0;
                               int length = input.length;
                               for (var i = 0; i < length; i++) {
                                 // get digits in reverse order
                                 int digit = int.parse(input[length - i - 1]);

                                 // every 2nd number multiply with 2
                                 if (i % 2 == 1) {
                                   digit *= 2;
                                 }
                                 sum += digit > 9 ? (digit - 9) : digit;
                               }

                               if (sum % 10 == 0) {
                                 return null;
                               }

                               return AppLocalizations.of(context)
                                   .translate('invalid_value');
                               },
                             focusNode: numberFocusNode,
                             controller: widget.numberController,
                             onSave: (value) => paymentInfo['number'] = value,
                             textInputType: TextInputType.number,
                             hintText: AppLocalizations.of(context).translate("card_number"),
                           ),
                           SizedBox(
                             height: 14,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Expanded(
                                 child: CustomInputTextField(
                                   validator: (String value) {
                                     if (value.isEmpty&&value.length<=2) {
                                       return AppLocalizations.of(context)
                                           .translate('invalid_value');
                                     }
                                   },
                                   focusNode: monthFocusNode,
                                   onSave: (value) => paymentInfo['month'] = value,
                                   textInputType: TextInputType.number,
                                   hintText: AppLocalizations.of(context).translate("month"),
                                 ),
                               ),
                               SizedBox(
                                 width: 14,
                               ),
                               Expanded(
                                 child: CustomInputTextField(
                                   validator: (value) {
                                     if (value.isEmpty&&(value.length<=2||value.length==4)) {
                                       return AppLocalizations.of(context)
                                           .translate('invalid_value');
                                     }
                                   },
                                   focusNode: yearFocusNode,
                                   onSave: (value) => paymentInfo['year'] = value,
                                   textInputType: TextInputType.number,
                                   hintText: AppLocalizations.of(context).translate("year"),
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 14,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Expanded(
                                 child: CustomInputTextField(
                                   validator: (value) {
                                     if (value.length < 3 || value.length > 4) {
                                       return "CVV is invalid";
                                     }
                                   },

                                   obscure: true,
                                   onSave: (value) => paymentInfo['cvc'] = value,
                                   textInputType: TextInputType.number,
                                   focusNode: cvcFocusNode,
                                   hintText: AppLocalizations.of(context)
                                       .translate("ccv"),
                                 ),
                               ),
                               SizedBox(
                                 width: 14,
                               ),
                               Expanded(
                                 child: Text(
                                   AppLocalizations.of(context)
                                       .translate("ccv_description"),
                                   style: Theme.of(context)
                                       .textTheme
                                       .caption
                                       .copyWith(
                                     color: Color(0xFF999999),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 48,
                           )
                          ],
                        ),
                      ),
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
                      startText:
                          AppLocalizations.of(context).translate("discount"),
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
                      isLoading:isLoading,
                      label:
                          AppLocalizations.of(context).translate("do_order"),
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                      onPress:
                        selectedPaymentMethod == null
                            ? (){showScaffoldSnackBar(context: context,scaffoldKey: _scaffoldKey, message:AppLocalizations.of(context).translate("please_select_payment_method"));}
                            : () {
                          if (!_formKey.currentState.validate()) {
                            // Invalid!
                            return;
                          }else if(selectedPaymentMethodId != "cod") {
                            _formKey.currentState.save();
                          }
                        OrderModel order=OrderModel(createdAt: DateTime.now(),total: BlocProvider.of<CartBloc>(context).totalPrice);
                        order.paymentMethodTitle=selectedPaymentMethod.title;
                        order.shippingMethodTitle=widget.shippingMethod.id;
                        order.shipping=widget.addressModel;
                        order.paymentMethod=selectedPaymentMethod;
                        order.billing=widget.addressModel;
                        order.coupon=widget.coupon;
                        order.shippingMethod=widget.shippingMethod;
                        order.lineItems=BlocProvider.of<CartBloc>(context).productIdToProductItem.values.toList();
                        BlocProvider.of<OrdersBloc>(context).add(CreateOrder(order));
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                              content: Text(
                                AppLocalizations.of(context).translate("please_wait"),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                              ),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> makePaymentWebView(Map<String, dynamic> params) async {
    try {
      if (params["token"] == null) {
        final snackBar = SnackBar(
          content: Text("Payment WebView doesn't support Guest Checkout"),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentWebview(
                url: "https://api.moyasar.com/v1/payments.html",
                onFinish: (number) {
                })),
      );
    } catch (e) {

      final snackBar = SnackBar(
        content: Text(e.toString()),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void onPaymentMethodChanged(PaymentMethod paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
      selectedPaymentMethodId = paymentMethod.id;
    });
  }
}

class PaymentMethodComponent extends StatelessWidget {
  const PaymentMethodComponent({
    Key key,
    @required PaymentMethodBloc paymentBloc,
    @required this.selectedPaymentMethodId,
    @required this.selectedPaymentMethod,
    @required this.onPaymentMethodChange,
  })  : _paymentBloc = paymentBloc,
        super(key: key);

  final PaymentMethodBloc _paymentBloc;
  final String selectedPaymentMethodId;
  final PaymentMethod selectedPaymentMethod;
  final Function onPaymentMethodChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocProvider<PaymentMethodBloc>(
            create: (context) => _paymentBloc,
            child: BlocListener<PaymentMethodBloc, PaymentMethodState>(
              listener: (context,state){
                if (state is PaymentMethodListLoadedState) {
                  if(selectedPaymentMethod == null){
                   for(PaymentMethod payment in state.paymentMethods) {
                     if(payment.id == selectedPaymentMethodId){
                       onPaymentMethodChange(payment);
                     }
                   }
                  }
                  if(selectedPaymentMethodId == null && state.paymentMethods.length == 1){
                    onPaymentMethodChange(state.paymentMethods.first);
                  }
                }
              },
              child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                  builder: (context, state) {
                if (state is PaymentMethodLoadingState) {
                  return Container(
                    margin: EdgeInsets.only(top: 28),
                    child: LoadingWidget(),
                  );
                } else if (state is PaymentMethodListLoadedState) {
                  return Column(
                    children: state.paymentMethods.map((paymentMethod) {
                      return Container(
                        color: AppColors.customGreyLevels[200].withOpacity(0.2),
                        padding: EdgeInsets.all(22),
                        margin: EdgeInsets.only(bottom: 18),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  paymentMethod.title,
                                  style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w400),
                                ),
                                CustomRadioButton(
                                  value: selectedPaymentMethodId == paymentMethod.id,
                                  onPressed: (value) {
                                    onPaymentMethodChange(paymentMethod);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is PaymentMethodErrorState) {
                  return Center(
                    child: GenericState(
                      imagePath: Constants.imagePath["error"],
                      titleKey: "error_title",
                      bodyKey: state.message,
                      removeButton: true,
                    ),
                  );
                }
                return Center(
                  child: GenericState(
                    imagePath: Constants.imagePath["error"],
                    titleKey: "error_title",
                    bodyKey: "error_body",
                    removeButton: true,
                  ),
                );
              }),
            )),
        Container(
          height: 1,
          color: AppColors.customGreyLevels[200].withOpacity(0.5),
        ),
        SizedBox(
          height: 30,
        ),
        // Column(
        //   children: <Widget>[
        //     selectedPaymentMethodId != "cod" && selectedPaymentMethod != null
        //         ? Form(
        //             child: Column(
        //               children: <Widget>[
        //                 CustomInputTextField(
        //                   validator: () {},
        //                   hintText: AppLocalizations.of(context)
        //                       .translate("card_holder"),
        //                 ),
        //                 SizedBox(
        //                   height: 14,
        //                 ),
        //                 CustomInputTextField(
        //                   validator: () {},
        //                   hintText: AppLocalizations.of(context)
        //                       .translate("card_number"),
        //                   obscure: true,
        //                 ),
        //                 SizedBox(
        //                   height: 14,
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: <Widget>[
        //                     Expanded(
        //                       child: Container(
        //                         height: 50,
        //                         padding: EdgeInsets.symmetric(horizontal: 8),
        //                         child: Align(
        //                           alignment: AlignmentDirectional.centerStart,
        //                           child: Text(
        //                             AppLocalizations.of(context)
        //                                 .translate("month"),
        //                           ),
        //                         ),
        //                         decoration: BoxDecoration(
        //                           border: Border.all(
        //                             color: AppColors.customGreyLevels[200]
        //                                 .withOpacity(0.6),
        //                             width: 1.5,
        //                           ),
        //                           borderRadius: BorderRadius.all(
        //                             Radius.circular(5),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 14,
        //                     ),
        //                     Expanded(
        //                       child: Container(
        //                         height: 50,
        //                         padding: EdgeInsets.symmetric(horizontal: 8),
        //                         child: Align(
        //                           alignment: AlignmentDirectional.centerStart,
        //                           child: Text(
        //                             AppLocalizations.of(context)
        //                                 .translate("year"),
        //                           ),
        //                         ),
        //                         decoration: BoxDecoration(
        //                           border: Border.all(
        //                             color: AppColors.customGreyLevels[200]
        //                                 .withOpacity(0.6),
        //                             width: 1.5,
        //                           ),
        //                           borderRadius: BorderRadius.all(
        //                             Radius.circular(5),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(
        //                   height: 14,
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: <Widget>[
        //                     Expanded(
        //                       child: CustomInputTextField(
        //                         validator: () {},
        //                         obscure: true,
        //                         hintText: AppLocalizations.of(context)
        //                             .translate("ccv"),
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 14,
        //                     ),
        //                     Expanded(
        //                       child: Text(
        //                         AppLocalizations.of(context)
        //                             .translate("ccv_description"),
        //                         style: Theme.of(context)
        //                             .textTheme
        //                             .caption
        //                             .copyWith(
        //                               color: Color(0xFF999999),
        //                             ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(
        //                   height: 48,
        //                 ),
        //               ],
        //             ),
        //           )
        //         : Container(),
        //   ],
        // ),
      ],
    );
  }
}
