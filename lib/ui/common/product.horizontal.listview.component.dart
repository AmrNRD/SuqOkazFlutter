import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductHorizontalListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductHorizontalListView({
    Key key,
    this.products,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: screenAwareSize(230, context),
          child: ListView.builder(
            itemCount: products.length,
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return ProductCardComponent(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
