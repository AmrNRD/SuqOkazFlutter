import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/common/custom_raised_button.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/ui/common/invoice.component.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.product.component.dart';
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
  @override
  void initState() {
    super.initState();
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WishlistBloc, WishlistState>(
      listener: (context, state) {
        if (state is WishlistLoadedState) {
          setState(() {
            wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
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
                      validator: (value) {
                        return true;
                      },
                      maxLines: 1,
                      minLines: 1,
                      textInputType: TextInputType.multiline,
                      isCollapes: true,
                      onFieldSubmit: (_) {},
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
                    endText: AppLocalizations.of(context).translate("currency", replacement: "0.0"),
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
                      Navigator.pushNamed(context, Constants.checkoutPage);
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
