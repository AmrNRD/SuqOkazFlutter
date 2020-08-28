import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/modules/product_details/components/carousal.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.consulting.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.statusbar.component.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel productModel;
  final _selectedIndex = 0;

  const ProductDetailsPage({
    Key key,
    @required this.productModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //TODO: translate
        text: AppLocalizations.of(context).translate(
          "Product Details",
          defaultText: "Product Details",
        ),
        canPop: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              ProductStatusBarComponent(
                inStock: productModel.inStock,
              ),
              CustomCrousalComponent(
                images: productModel.images,
              ),
              ProductDetailsComponent(
                productModel: productModel,
              ),
              ProductConsultingDetailsComponent(
                productModel: productModel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
