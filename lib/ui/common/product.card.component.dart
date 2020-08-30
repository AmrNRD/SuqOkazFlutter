import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';
import '../style/app.colors.dart';

class ProductCardComponent extends StatelessWidget {
  final Function onItemTap;
  final ProductModel product;
  final bool allowMargin;
  final bool isInCart;

  const ProductCardComponent(
      {Key key,
      this.onItemTap,
      @required this.product,
      this.isInCart = false,
      this.allowMargin = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onItemTap != null) ? onItemTap : null,
      child: Container(
        width: 140,
        margin: EdgeInsetsDirectional.only(end: allowMargin ? 8 : 0),
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
        child: Container(
          child: Stack(
            children: [
              Container(
                height: screenAwareSize(130, context),
                child: ImageProcessor.image(
                  url: product.imageFeature,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: screenAwareSize(130, context),
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            //widget.product.name,
                            product.name,
                            style: Theme.of(context).textTheme.bodyText2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).translate(
                                  "currency",
                                  replacement: product.price,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            isInCart
                                ? SvgPicture.asset(
                                    "assets/icons/cart_button_selected_icon.svg",
                                    height: 28,
                                    width: 28,
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/product_cart_icon.svg",
                                    height: 28,
                                    width: 28,
                                  ),
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
                                "Sale",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.accentColor2),
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
