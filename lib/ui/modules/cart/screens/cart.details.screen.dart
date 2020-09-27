import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/coupon/coupon_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/repositories/coupon.repository.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/ui/common/invoice.component.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.product.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class CartDetailsScreen extends StatefulWidget {
  final List<ProductItem> productItems;

  CartDetailsScreen({Key key, this.productItems}) : super(key: key);

  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  final TextEditingController discountController = TextEditingController();
  Map<String, Null> wishListMaper = {};

  bool isLoading = false;
  Timer _debounce;

  double discount=0;
  Icon couponSuffixIcon;
  Color couponBorderColor;
  Coupon coupon;

  int productId = 0;
  int variationId = 0;

  CouponBloc couponBloc;

  @override
  void initState() {
    super.initState();
    couponBloc=new CouponBloc(new CouponDataRepository());
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WishlistBloc, WishlistState>(
      listener: (context, state) {
        if (state is WishlistLoadedState) {
          setState(() {
            wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
            isLoading = false;
          });
        } else if (state is WishlistLoadingState) {
          setState(() {
            isLoading = true;
            productId = state.productId;
            variationId = state.variationId;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: widget.productItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductCartComponent(
                          isLoading: (productId == widget.productItems[index].productId &&
                                  variationId == widget.productItems[index].variationId)
                              ? isLoading
                              : false,
                          productItem: widget.productItems[index],
                          variationId: widget.productItems[index].variationId,
                          isInFav: wishListMaper.containsKey(widget.productItems[index].productId.toString() +
                                  widget.productItems[index].variationId.toString()) ??
                              false,
                        );
                      },
                    ),
                    SizedBox(
                      height: AppDimens.marginDefault20,
                    ),
                   BlocProvider<CouponBloc>(
                     create: (context)=>couponBloc,
                     child: BlocListener<CouponBloc,CouponState>(
                       listener: (context,state){
                         if(state is CouponLoading){
                          setState(() {
                            couponBorderColor=AppColors.customGreyLevels[200].withOpacity(0.6);
                            discount=0;
                            coupon=null;
                            couponSuffixIcon=Icon(Icons.swap_vertical_circle);
                          });
                         }else if(state is CouponLoaded){
                           setState(() {
                             couponBorderColor=Colors.green.withOpacity(0.6);
                             discount=state.coupon.amount;
                             coupon=state.coupon;
                             couponSuffixIcon=Icon(FontAwesomeIcons.check);
                           });
                         }else if(state is CouponError){
                           setState(() {
                             couponBorderColor=Colors.redAccent;
                             discount=0;
                             coupon=null;
                             couponSuffixIcon=Icon(FontAwesomeIcons.times);
                           });
                         }
                       },
                       child: Column(
                         children: [
                           Text(
                             AppLocalizations.of(context).translate("discount_title"),
                             style: Theme.of(context).textTheme.headline2,
                             textAlign: TextAlign.center,
                           ),
                           SizedBox(
                             height: AppDimens.marginDefault12,
                           ),
                           CustomInputTextField(
                             controller: discountController,
                             borderColor: couponBorderColor,
                             suffixIcon: couponSuffixIcon,
                             validator: (value) {
                               return true;
                             },
                             onChange: (value){
                               if (_debounce?.isActive ?? false) {
                                 _debounce.cancel();
                               }

                               _debounce = Timer(const Duration(milliseconds: 500), () async {
                                 if (value.length >= 3) {
                                  couponBloc.add(GetCoupon(value));
                                 } else {

                                 }
                               });
                             },
                             textInputType: TextInputType.text,

                           ),
                         ],
                       ),
                     ),
                   ),
                    SizedBox(
                      height: screenAwareSize(180, context),
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
                      replacement: BlocProvider.of<CartBloc>(context).totalPrice.toStringAsFixed(2),
                    ),
                    highlight: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InvoiceComponent(
                    startText: AppLocalizations.of(context).translate("discount"),
                    endText: AppLocalizations.of(context).translate("currency", replacement: discount.toStringAsFixed(2)),
                    isDiscount: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InvoiceComponent(
                    startText: AppLocalizations.of(context).translate("total"),
                    endText: AppLocalizations.of(context).translate(
                      "currency",
                      replacement: BlocProvider.of<CartBloc>(context).totalPrice.toStringAsFixed(2),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomRaisedButton(
                    isLoading: false,
                    label: AppLocalizations.of(context).translate("checkout"),
                    onPress: () {
                      Navigator.pushNamed(context, Constants.checkoutPage,arguments: [widget.productItems,discount,coupon]);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
