import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.item.counter.compnent.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.item.fav.remove.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductCartComponent extends StatelessWidget {
  final ProductItem productItem;

  const ProductCartComponent({
    Key key,
    @required this.productItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productItem.name,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      AppLocalizations.of(context).translate(
                        "currency",
                        replacement: productItem.price,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenAwareSize(90, context),
                width: screenAwareWidth(90, context),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFF2F2F2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.05),
                      blurRadius: 0,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: ImageProcessor.image(
                  url: productItem.featuredImage,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CartItemCounter(
                productItem: productItem,
              ),
              CartItemFavRemoveComponent(
                productItem: productItem,
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
