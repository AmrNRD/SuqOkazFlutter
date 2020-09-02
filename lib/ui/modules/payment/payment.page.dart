import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/payment_method/payment_method_bloc.dart';
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
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class PaymentPage extends StatefulWidget {
  final AddressModel addressModel;
  final ShippingMethod shippingMethod;
  const PaymentPage(
      {Key key, @required this.addressModel, @required this.shippingMethod})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod selectedPaymentMethod;
  String selectedPaymentMethodId;

  PaymentMethodBloc _paymentBloc;
  @override
  void initState() {
    selectedPaymentMethodId = "cod";
    super.initState();
    _paymentBloc = new PaymentMethodBloc(new PaymentMethodDataRepository());
    _paymentBloc.add(GetAllPaymentMethodEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        canPop: true,
        text: AppLocalizations.of(context).translate("payment"),
      ),
      body: Stack(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.shippingMethod.title),
                          Divider(),
                          Text(widget.shippingMethod.description),
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
                        .translate("currency", replacement: "0.0"),
                    isDiscount: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InvoiceComponent(
                    startText:
                        AppLocalizations.of(context).translate("delivery"),
                    endText: AppLocalizations.of(context)
                        .translate("currency", replacement: "0.0"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InvoiceComponent(
                    startText: AppLocalizations.of(context).translate("total"),
                    endText: AppLocalizations.of(context).translate(
                      "currency",
                      replacement: BlocProvider.of<CartBloc>(context)
                          .totalPrice
                          .toStringAsFixed(2),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomRaisedButton(
                    isLoading: false,
                    label:
                        AppLocalizations.of(context).translate("payment_small"),
                    onPress: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              CustomRadioButton(
                                value:
                                    selectedPaymentMethodId == paymentMethod.id,
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
            })),
        Container(
          height: 1,
          color: AppColors.customGreyLevels[200].withOpacity(0.5),
        ),
        SizedBox(
          height: 30,
        ),
        Column(
          children: <Widget>[
            selectedPaymentMethodId != "cod" && selectedPaymentMethod != null
                ? Form(
                    child: Column(
                      children: <Widget>[
                        CustomInputTextField(
                          validator: () {},
                          hintText: AppLocalizations.of(context)
                              .translate("card_holder"),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        CustomInputTextField(
                          validator: () {},
                          hintText: AppLocalizations.of(context)
                              .translate("card_number"),
                          obscure: true,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("month"),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.customGreyLevels[200]
                                        .withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("year"),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.customGreyLevels[200]
                                        .withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
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
                                validator: () {},
                                obscure: true,
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
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
