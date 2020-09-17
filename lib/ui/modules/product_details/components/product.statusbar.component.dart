import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductStatusBarComponent extends StatelessWidget {
  final bool inStock;
  final bool isInFav;
  final int productId;
  final int variationId;
  final bool isLoading;

  const ProductStatusBarComponent({
    Key key,
    this.inStock = false,
    this.isInFav = false,
    @required this.productId,
    @required this.variationId,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            inStock
                ? Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/right_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context).translate(
                          "in_stock",
                          defaultText: "Available",
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Icon(
                        Icons.do_not_disturb_on,
                        color: Colors.red,
                        size: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context).translate(
                          "out_of_stock",
                          defaultText: "Out of Stock",
                        ),
                      ),
                    ],
                  ),
            !isLoading
                ? Root.user != null
                    ? InkWell(
                        onTap: () {
                          if (!isInFav) {
                            BlocProvider.of<WishlistBloc>(context).add(
                              AddProductToWishListEvent(
                                productId: productId,
                                varId: variationId,
                              ),
                            );
                          } else {
                            BlocProvider.of<WishlistBloc>(context).add(
                              RemoveWishListItemEvent(
                                productId: productId,
                                varId: variationId,
                              ),
                            );
                          }
                        },
                        child: isInFav
                            ? SvgPicture.asset(
                                "assets/icons/fav_selected_icon.svg",
                                height: 20,
                                width: 24,
                              )
                            : SvgPicture.asset(
                                "assets/icons/fav_icon.svg",
                                height: 20,
                                width: 20,
                              ),
                      )
                    : Container()
                : Container(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
