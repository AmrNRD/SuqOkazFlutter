import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/carousel.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.add.to.cart.button.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.consulting.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.statusbar.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel productModel;

  ProductDetailsPage({
    Key key,
    @required this.productModel,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductBloc productDetailsBloc = ProductBloc(ProductsRepository());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedVariation = 0;

  int productQuantity = 1;

  int variationId = 0;

  updateProductSettings(int quantity, int variationId, int selectedVariationIndex) {
    setState(() {
      productQuantity = quantity;
      this.variationId = variationId;
      selectedVariation = selectedVariationIndex;
    });
  }

  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReviewBloc>(context).add(
      GetProductReviewsEvent(
        widget.productModel.id.toString(),
      ),
    );

    productDetailsBloc.add(GetProductVariationsEvent(widget.productModel));

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<ProductBloc, ProductState>(
        cubit: productDetailsBloc,
        builder: (BuildContext context, ProductState state) {
          if (state is ProductVariationsLoadedState) {
            return BlocListener<CartBloc, CartState>(
              listener: (context, state) {
                if (state is CartLoadedState) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      content: Text(
                        AppLocalizations.of(context).translate("cart_add_success"),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
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
                              inStock: widget.productModel.variations[selectedVariation].inStock,
                            ),
                            CustomCarouselComponent(
                              images: widget.productModel.images,
                            ),
                            ProductDetailsComponent(
                              productModel: widget.productModel,
                              updateSettings: updateProductSettings,
                              selectedVariation: selectedVariation,
                            ),
                            ProductConsultingDetailsComponent(
                              scrollController: _scrollController,
                              productModel: widget.productModel,
                              selectedVariation: selectedVariation,
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
                      productModel: widget.productModel,
                      activeButton: widget.productModel.variations[selectedVariation].inStock,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductsLoadingState) {
            return Center(
              child: LoadingWidget(),
            );
          } else if (state is ProductsErrorState) {
            return Center(
              child: GenericState(
                size: 40,
                margin: 8,
                fontSize: 16,
                removeButton: true,
                imagePath: Constants.imagePath["error"],
                //TODO: Translate
                titleKey: AppLocalizations.of(context).translate("todo", defaultText: "Sad Error Title :("),
                bodyKey: AppLocalizations.of(context).translate(
                  "todo",
                  defaultText: state.message,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
