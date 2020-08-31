import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class CartItemFavRemoveComponent extends StatelessWidget {
  final ProductItem productItem;

  const CartItemFavRemoveComponent({
    Key key,
    @required this.productItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/heart_icon.svg",
                height: screenAwareSize(16, context),
                width: screenAwareWidth(16, context),
              ),
              SizedBox(
                width: AppDimens.marginDefault8,
              ),
              Text(
                AppLocalizations.of(context).translate("move_wishlist",
                    defaultText: "Move to wishlist"),
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Color(0xFFB1B1B1),
                    ),
              ),
            ],
          ),
        ),
        Container(
          height: 18,
          width: 0.5,
          color: AppColors.customGreyLevels[200],
          margin: EdgeInsets.symmetric(horizontal: 12),
        ),
        InkWell(
          onTap: () {
            BlocProvider.of<CartBloc>(context).add(
              RemovedItemInCartEvent(productItem.productId),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                "assets/images/delete_gray_icon.svg",
                height: screenAwareSize(16, context),
                width: screenAwareWidth(16, context),
              ),
              SizedBox(width: AppDimens.marginDefault8),
              Text(
                AppLocalizations.of(context)
                    .translate("remove", defaultText: "Remove"),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Color(0xFFB1B1B1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
