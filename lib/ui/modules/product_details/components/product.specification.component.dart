import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';

class ProductSpecificationComponent extends StatelessWidget {
  final List<ProductAttribute> productAttributes;

  const ProductSpecificationComponent({
    Key key,
    @required this.productAttributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productAttributes.length,
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          color: index % 2 == 0
              ? Color(0xFFC4C4C4).withOpacity(0.1)
              : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  productAttributes[index].name,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Expanded(
                child: Text(
                  productAttributes[index].options.toString(),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
