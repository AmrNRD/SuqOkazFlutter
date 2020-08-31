import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class AddToCartButton extends StatefulWidget {
  final int productQuantity;
  final ProductModel productModel;
  AddToCartButton({
    Key key,
    this.productQuantity,
    @required this.productModel,
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int productQuantity;

  @override
  void initState() {
    super.initState();
    productQuantity = widget.productQuantity ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.marginEdgeCase24,
            vertical: AppDimens.marginDefault12,
          ),
          color: Color(0xFFF0F0F0),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "-",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: productQuantity > 1
                              ? () {
                                  setState(() {
                                    if (productQuantity > 1) {
                                      productQuantity--;
                                    }
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      productQuantity.toString(),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "+",
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              productQuantity++;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              color: AppColors.primaryColors[50],
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).padding.bottom <= 20
                          ? 20
                          : MediaQuery.of(context).padding.bottom - 5),
                  child: Text(
                    AppLocalizations.of(context).translate("add_cart"),
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CartBloc>(context).add(
                      AddProductToCartEvent(
                        widget.productModel,
                        productQuantity,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
