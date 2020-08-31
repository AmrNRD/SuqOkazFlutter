import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReviewBloc>(context).add(
      GetProductReviewsEvent(
        productModel.id.toString(),
      ),
    );

    ScrollController _scrollController = ScrollController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        //TODO: translate
        text: AppLocalizations.of(context).translate(
          "Product Details",
          defaultText: "Product Details",
        ),
        canPop: true,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoadedState) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: Colors.green,
                content: Text(
                  AppLocalizations.of(context).translate("cart_add_success"),
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: Stack(
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
                        scaffoldKey: _scaffoldKey,
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
              child: AddToCartButton(
                productModel: productModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
