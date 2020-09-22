import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

import '../style/app.colors.dart';

class ProductBoxComponent extends StatefulWidget {
  final Function onItemTap;
  final isCartItem;
  final ProductItem product;

  const ProductBoxComponent({
    Key key,
    this.product,
    this.onItemTap,
    this.isCartItem = false,
  }) : super(key: key);

  @override
  _ProductBoxComponentState createState() => _ProductBoxComponentState();
}

class _ProductBoxComponentState extends State<ProductBoxComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("-------------------------------------------------d");
    print(widget.product.imageFeature);
    // Build view widget
    return GestureDetector(
      onTap: (widget.onItemTap != null) ? widget.onItemTap : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsetsDirectional.only(
            top: AppDimens.marginDefault8, bottom: AppDimens.marginDefault8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.customGreyLevels[200].withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              height: screenAwareSize(80, context),
              width: screenAwareSize(80, context),
              child: ImageProcessor.image(
                url: widget.product.imageFeature,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: AppDimens.marginDefault16,
                    end: AppDimens.marginDefault16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsetsDirectional.only(end: 8),
                              child: Text(
                                (widget.product.name != null)
                                    ? "${widget.product.name}"
                                    : "NA",
                                style: Theme.of(context).textTheme.headline2,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate(
                                  "currency",
                                  replacement: "${widget.product.total}",
                                ),
                                style: AppTheme.bodySmall.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppDimens.marginDefault8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate(
                            "quantity",
                            replacement: (widget.product.quantity != null)
                                ? "${widget.product.quantity}"
                                : "0",
                          ),
                          style: AppTheme.bodySmall.copyWith(
                              color: AppColors.primaryColors[200],
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),

                      ],
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
