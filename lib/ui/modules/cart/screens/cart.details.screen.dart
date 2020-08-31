import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.product.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class CartDetailsScreen extends StatelessWidget {
  final List<ProductItem> productItems;
  final TextEditingController discountController = TextEditingController();

  CartDetailsScreen({Key key, this.productItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: productItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCartComponent(
                      productItem: productItems[index],
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
                  height: screenAwareSize(120, context),
                ),
              ],
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
                      .translate("currency", replacement: "0.0"),
                  isDiscount: true,
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
              ],
            ),
          ),
        )
      ],
    );
  }
}

class InvoiceComponent extends StatelessWidget {
  final bool highlight;
  final bool isDiscount;
  final String startText;
  final String endText;

  const InvoiceComponent({
    Key key,
    this.highlight = false,
    this.isDiscount = false,
    this.startText,
    this.endText,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          startText,
          style: Theme.of(context).textTheme.headline2.copyWith(
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        Text(
          endText,
          style: Theme.of(context).textTheme.headline2.copyWith(
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w300,
                color: isDiscount
                    ? Color(0xFF2D8F1D)
                    : AppColors.primaryColors[200],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
