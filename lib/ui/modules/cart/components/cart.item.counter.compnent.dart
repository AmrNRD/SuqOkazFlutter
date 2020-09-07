import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class CartItemCounter extends StatelessWidget {
  final ProductItem productItem;

  const CartItemCounter({Key key, @required this.productItem})
      : super(key: key);
  @override
  build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: AppColors.primaryColors[50],
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(5),
                  bottomStart: Radius.circular(5),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "-",
                      style: Theme.of(context).textTheme.headline2.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (productItem.quantity > 1) {
                            BlocProvider.of<CartBloc>(context).add(
                              DecreaseItemInCartEvent(
                                productItem.productId,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 25,
              width: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColors[50],
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  productItem.quantity.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColors[50],
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(5),
                        bottomEnd: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
                            IncreaseItemInCartEvent(
                              productItem.productId,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
