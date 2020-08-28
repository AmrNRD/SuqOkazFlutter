import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.description.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.button.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.review.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.specification.component.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductConsultingDetailsComponent extends StatefulWidget {
  final ProductModel productModel;

  const ProductConsultingDetailsComponent(
      {Key key, @required this.productModel})
      : super(key: key);
  @override
  _ProductConsultingDetailsComponentState createState() =>
      _ProductConsultingDetailsComponentState();
}

class _ProductConsultingDetailsComponentState
    extends State<ProductConsultingDetailsComponent> {
  int _selectedIndex = 0;

  List<Widget> body;

  @override
  void initState() {
    super.initState();

    widget.productModel.infors.forEach((element) {
      print(element.name);
    });
    widget.productModel.infors.forEach((element) {
      print(element.options);
    });

    body = [
      ProductDescriptionComponent(
        description: widget.productModel.description,
      ),
      ProductSpecificationComponent(
        productAttributes: widget.productModel.infors,
      ),
      ProductDetailsReviewComponent(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        Row(
          children: <Widget>[
            ProductDetailsTab(
              tabName: AppLocalizations.of(context)
                  .translate("todo", defaultText: "Description")
                  .toUpperCase(),
              isSelected: _selectedIndex == 0,
              onTap: _selectedIndex == 0
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
            ),
            ProductDetailsTab(
              tabName: AppLocalizations.of(context)
                  .translate("todo", defaultText: "Specifications")
                  .toUpperCase(),
              isSelected: _selectedIndex == 1,
              onTap: _selectedIndex == 1
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
            ),
            ProductDetailsTab(
              tabName: AppLocalizations.of(context)
                  .translate("todo", defaultText: "Reviews")
                  .toUpperCase(),
              isSelected: _selectedIndex == 2,
              onTap: _selectedIndex == 2
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        body[_selectedIndex],
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
