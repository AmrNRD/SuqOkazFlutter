import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/star.rating.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductDetailsComponent extends StatelessWidget {
  const ProductDetailsComponent({
    Key key,
    @required this.productModel,
  }) : super(key: key);

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productModel.categoryName,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w400),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppDimens.marginSeparator4,
                  ),
                  Text(
                    productModel.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppDimens.marginSeparator8,
                  ),
                  SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: productModel.averageRating,
                      size: 16.0,
                      color: AppColors.primaryColors[50],
                      borderColor: AppColors.primaryColors[50],
                      label: Text(
                        AppLocalizations.of(context).translate(
                          "review_count",
                          //TODO : SAD
                          replacement: "0",
                        ),
                        style: Theme.of(context).textTheme.headline3.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.customGreyLevels[100]),
                      ),
                      spacing: 0.0)
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                productModel.onSale
                    ? Container(
                        child: Text(
                          AppLocalizations.of(context).translate(
                            "currency",
                            replacement: double.parse(
                              productModel.salePrice,
                            ).toStringAsFixed(2),
                          ),
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough),
                          maxLines: 3,
                          softWrap: true,
                        ),
                        margin: EdgeInsetsDirectional.only(
                            start: AppDimens.marginDefault16),
                      )
                    : Container(),
                Container(
                  child: Text(
                    AppLocalizations.of(context).translate(
                      "currency",
                      replacement:
                          double.parse(productModel.price).toStringAsFixed(2),
                    ),
                    maxLines: 3,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsetsDirectional.only(
                    start: AppDimens.marginDefault16,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
