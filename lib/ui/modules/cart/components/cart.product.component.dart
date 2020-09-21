import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.item.counter.compnent.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.item.fav.remove.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductCartComponent extends StatefulWidget {
  final ProductItem productItem;
  final int variationId;
  final bool isInFav;
  final bool isLoading;

  const ProductCartComponent({
    Key key,
    @required this.productItem,
    @required this.variationId,
    this.isInFav = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _ProductCartComponentState createState() => _ProductCartComponentState();
}

class _ProductCartComponentState extends State<ProductCartComponent> {
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
                      widget.productItem.name,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ...widget.productItem.attribute.map(
                      (e) => Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          e.name.toUpperCase() + " : " + e.option.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate(
                        "currency",
                        replacement: widget.productItem.price,
                      ),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w700),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: ImageProcessor.image(
                  url: widget.productItem.featuredImage,
                  fit: BoxFit.cover,
                )),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CartItemCounter(
                productItem: widget.productItem,
                variationId: widget.variationId,
              ),
              CartItemFavRemoveComponent(
                isLoading: widget.isLoading,
                isInFav: widget.isInFav,
                productItem: widget.productItem,
                variationId: widget.variationId,
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
