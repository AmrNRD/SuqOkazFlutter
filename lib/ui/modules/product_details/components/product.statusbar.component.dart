import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductStatusBarComponent extends StatelessWidget {
  final bool inStock;

  const ProductStatusBarComponent({Key key, this.inStock = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                          defaultText: "Avilable",
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/right_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of(context).translate(
                          "out_of_stock",
                          defaultText: "Out of Stock",
                        ),
                      ),
                    ],
                  ),
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 26,
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
