import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';
import '../style/app.colors.dart';

class ProductCardComponent extends StatelessWidget {
  final Function onItemTap;
  final ProductModel product;
  final List<Attribute> attribute;
  final int variationId;
  final bool allowMargin;
  final bool isInCart;
  final bool inInFav;
  final double imageHeight;

  const ProductCardComponent({
    Key key,
    this.onItemTap,
    @required this.product,
    this.isInCart = false,
    this.allowMargin = true,
    this.inInFav = false,
    @required this.variationId,
    @required this.attribute,
    this.imageHeight = 130,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsetsDirectional.only(
        end: allowMargin ? 8 : 0,
      ),
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
      child: GestureDetector(
        onTap: (onItemTap != null) ? onItemTap : null,
        child: Stack(
          children: [
            Container(
              height: screenAwareSize(imageHeight, context),
              child: product.imageFeature != null ? ImageProcessor.image(
                url: product.imageFeature,
                fit: BoxFit.cover,
              ) : SvgPicture.asset(
                          "assets/images/splash_background_pattern.svg",
                         fit: BoxFit.cover,
                       ),
            ),
            Positioned(
              top: screenAwareSize(imageHeight, context),
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      //widget.product.name,
                      product.name ?? "",
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "currency",
                                replacement: product.price ?? "",
                              ),
                              style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w700),
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
                          //           height: 32,
                          //           width: 32,
                          //         )
                          //       : SvgPicture.asset(
                          //           "assets/icons/product_cart_icon.svg",
                          //           height: 32,
                          //           width: 32,
                          //         ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    product.onSale ?? false
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor2.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context).translate("sale"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w500, color: AppColors.accentColor2),
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      child: Root.user != null
                          ? InkWell(
                              onTap: () {
                                if (!inInFav) {
                                  BlocProvider.of<WishlistBloc>(context).add(
                                    AddProductToWishListEvent(
                                      productModel: product,
                                      varId: variationId,
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<WishlistBloc>(context).add(
                                    RemoveWishListItemEvent(
                                      productId: product.id,
                                      varId: variationId,
                                    ),
                                  );
                                }
                              },
                              child: inInFav
                                  ? SvgPicture.asset(
                                      "assets/icons/fav_selected_icon.svg",
                                      height: 20,
                                      width: 20,
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/fav_icon.svg",
                                      height: 20,
                                      width: 20,
                                    ),
                            )
                          : Container(),
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
}
