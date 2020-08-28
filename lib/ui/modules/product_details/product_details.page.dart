import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/modules/product_details/components/carousal.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.consulting.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.statusbar.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
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
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SingleChildScrollView(
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
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.marginEdgeCase24,
                    vertical: AppDimens.marginDefault12,
                  ),
                  color: Color(0xFFF0F0F0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Text(
                                "-",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              "1",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "+",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      color: AppColors.primaryColors[50],
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).padding.bottom <=
                                      20
                                  ? 20
                                  : MediaQuery.of(context).padding.bottom - 5),
                          child: Text(
                            AppLocalizations.of(context).translate("add_cart"),
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
