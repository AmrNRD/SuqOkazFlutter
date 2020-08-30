import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/modules/product_details/components/carousel.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.add.to.cart.button.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.consulting.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.statusbar.component.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel productModel;

  ProductDetailsPage({
    Key key,
    @required this.productModel,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReviewBloc>(context).add(
      GetProductReviewsEvent(
        productModel.id.toString(),
      ),
    );

    ScrollController _scrollController = ScrollController();

    return Scaffold(
      key: scaffoldKey,
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
              controller: _scrollController,
              child: Container(
                margin: EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    ProductStatusBarComponent(
                      inStock: productModel.inStock,
                    ),
                    CustomCarouselComponent(
                      images: productModel.images,
                    ),
                    ProductDetailsComponent(
                      productModel: productModel,
                    ),
                    ProductConsultingDetailsComponent(
                      scrollController: _scrollController,
                      productModel: productModel,
                      scaffoldKey: scaffoldKey,
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
            child: AddToCartButton(),
          ),
        ],
      ),
    );
  }
}
