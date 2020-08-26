import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';
import '../style/app.colors.dart';

class ProductCardComponent extends StatefulWidget {
  final Function onItemTap;
  final ProductModel product;

  const ProductCardComponent(this.product, {Key key, this.onItemTap})
      : super(key: key);

  @override
  _ProductCardComponentState createState() => _ProductCardComponentState();
}

class _ProductCardComponentState extends State<ProductCardComponent> {
  @override
  Widget build(BuildContext context) {
    String currency = "0.0 SAR";
    try {
      /*currency = AppLocalizations.of(context).translate("currency", replacement: double.parse(widget.product.price).toStringAsFixed(2)
        .toString());*/
      currency = AppLocalizations.of(context)
          .translate("currency", defaultText: "SAR", replacement: "22.99 SAR");
    } catch (_) {}

    return GestureDetector(
      onTap: (widget.onItemTap != null) ? widget.onItemTap : null,
      child: Container(
        width: 170,
        margin: EdgeInsetsDirectional.only(end: AppDimens.marginDefault8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Color(0xFFF2F2F2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.05), blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              margin:
                  EdgeInsetsDirectional.only(bottom: AppDimens.marginDefault12),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 16,
                      start: 4,
                    ),
                    height: screenAwareSize(80, context),
                    child: ImageProcessor.image(
                      url:
                          "https://i1.wp.com/freepngimages.com/wp-content/uploads/2020/07/Playstation-5-games-console-transparent-background-png-image.png?fit=895%2C895",
                      //widget.product.imageFeature,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        start: AppDimens.marginDefault16,
                        end: AppDimens.marginDefault16,
                        top: AppDimens.marginDefault12),
                    child: Text(
                      //widget.product.name,
                      "Playstation 5 2TP With joystick",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontSize: 13),
                      maxLines: 2,
                      softWrap: true, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: AppDimens.marginDefault16,
                                end: AppDimens.marginDefault16),
                            child: Text(
                              "24,99 $currency",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(fontWeight: FontWeight.w800),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColors[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsetsDirectional.only(
                              end: AppDimens.marginDefault6,
                              start: AppDimens.marginDefault6,
                              top: AppDimens.marginDefault6,
                              bottom: AppDimens.marginDefault6),
                          margin: EdgeInsetsDirectional.only(
                              end: AppDimens.marginDefault16),
                          child: SvgPicture.asset(
                            "assets/icons/shopping_icon.svg",
                            color: Colors.white,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: AppDimens.marginDefault12,
                        start: AppDimens.marginDefault16,
                        end: AppDimens.marginDefault16),
                    child: Container(
                        padding: EdgeInsetsDirectional.only(
                            top: 3, bottom: 3, start: 6, end: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor2.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Sale",
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.accentColor2),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12, left: 14, right: 14),
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.customGreyLevels[200],
                      size: 24,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
