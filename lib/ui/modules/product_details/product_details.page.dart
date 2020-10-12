import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
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

  ProductModel productModel;

  int selectedVariation = 0;

  int productQuantity = 1;

  int variationId = 0;

  bool isLoading = false;

  bool apiProductLoaded = false;

  updateProductSettings(int quantity, int variationId, int selectedVariationIndex) {
    setState(() {
      productQuantity = quantity;
      this.variationId = variationId;
      selectedVariation = selectedVariationIndex;
    });
  }

  Map<String, Null> wishListMaper = {};
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    productModel = widget.productModel;

    BlocProvider.of<ReviewBloc>(context).add(
      GetProductReviewsEvent(
        productModel.id.toString(),
      ),
    );
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;

    productModel.loadedFromApi
        ? productDetailsBloc.add(GetProductDetailsEvent(productModel.id.toString()))
        : productDetailsBloc.add(GetProductVariationsEvent(productModel));

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
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
          if (state is ProductVariationsLoadedState || state is ProductDetailsLoadedState) {
            if (state is ProductDetailsLoadedState) {
              productModel = state.productModel;
              apiProductLoaded = true;
              productDetailsBloc.add(GetProductVariationsEvent(productModel));
            }
          } else if (state is ProductsLoadingState && !apiProductLoaded) {
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
                titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
                bodyKey: state.message,
              ),
            );
          }
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
                          BlocListener<WishlistBloc, WishlistState>(
                            listener: (context, state) {
                              if (state is WishlistLoadedState) {
                                setState(() {
                                  wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
                                  isLoading = false;
                                });
                              } else if (state is WishlistLoadingState) {
                                setState(() {
                                  isLoading = true;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: productModel.variations.isNotEmpty ? ProductStatusBarComponent(
                              productId: productModel.id,
                              variationId: variationId,
                              isLoading: isLoading,
                              inStock: productModel.variations[selectedVariation].inStock,
                              isInFav: wishListMaper.containsKey(
                                  productModel.id.toString() + productModel.variations[selectedVariation].id.toString()) ??
                                  false,
                            ) : Container(),
                          ),
                          CustomCarouselComponent(
                            images: productModel.images,
                          ),
                          ProductDetailsComponent(
                            productModel: productModel,
                            updateSettings: updateProductSettings,
                            selectedVariation: selectedVariation,
                          ),
                          ProductConsultingDetailsComponent(
                            scrollController: _scrollController,
                            productModel: productModel,
                            selectedVariation: selectedVariation,
                            scaffoldKey: _scaffoldKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                productModel.variations.isNotEmpty ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: AddToCartButton(
                    productModel: productModel,
                    activeButton: productModel.variations[selectedVariation].inStock,
                    attributes: productModel.variations[selectedVariation].attributes,
                    variationId: variationId,
                  ),
                ) : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
