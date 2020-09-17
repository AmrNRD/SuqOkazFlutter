import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductCardLongComponent extends StatelessWidget {
  final Function onItemTap;
  final ProductModel product;
  final List<Attribute> attribute;
  final int variationId;
  final bool allowMargin;
  final bool isInCart;
  final bool isInFav;
  final bool showAttributes;

  const ProductCardLongComponent({
    Key key,
    this.onItemTap,
    @required this.product,
    this.isInCart = false,
    this.allowMargin = true,
    this.isInFav = false,
    @required this.attribute,
    @required this.variationId,
    this.showAttributes = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(isInFav);
    return GestureDetector(
      onTap: (onItemTap != null) ? onItemTap : null,
      child: Container(
        height: 110,
        padding: EdgeInsets.all(16),
        margin: EdgeInsetsDirectional.only(end: allowMargin ? 8 : 0, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Color(0xFFF2F2F2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: ImageProcessor.image(
                  url: product.imageFeature,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      showAttributes
                          ? Column(
                              children: product.variations[0].attributes
                                  .map(
                                    (e) => Container(
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                        e.name.toUpperCase() + " : " + e.option.toUpperCase(),
                                        style:
                                            Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context).translate(
                      "currency",
                      replacement: product.price,
                    ),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (!isInFav) {
                        BlocProvider.of<WishlistBloc>(context).add(
                          AddProductToWishListEvent(
                            productModel: product,
                            varId: product.variations[0].id,
                          ),
                        );
                      } else {
                        BlocProvider.of<WishlistBloc>(context).add(
                          RemoveWishListItemEvent(
                            productId: product.id,
                            varId: product.variations[0].id,
                          ),
                        );
                      }
                    },
                    child: isInFav
                        ? SvgPicture.asset(
                            "assets/icons/fav_selected_icon.svg",
                            height: 24,
                            width: 24,
                          )
                        : SvgPicture.asset(
                            "assets/icons/fav_icon.svg",
                            height: 24,
                            width: 24,
                          ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     isInCart
                  //         ? BlocProvider.of<CartBloc>(context).add(
                  //             RemovedItemInCartEvent(
                  //               product.id,
                  //               variationId,
                  //             ),
                  //           )
                  //         : BlocProvider.of<CartBloc>(context).add(
                  //             AddProductToCartEvent(
                  //               product,
                  //               1,
                  //               variationId,
                  //               attribute,
                  //             ),
                  //           );
                  //   },
                  //   child: isInCart
                  //       ? SvgPicture.asset(
                  //           "assets/icons/cart_button_selected_icon.svg",
                  //           height: 28,
                  //           width: 28,
                  //         )
                  //       : SvgPicture.asset(
                  //           "assets/icons/product_cart_icon.svg",
                  //           height: 28,
                  //           width: 28,
                  //         ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
