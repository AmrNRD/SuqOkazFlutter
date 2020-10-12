import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loadany/loadany_widget.dart';
import 'package:suqokaz/bloc/banner/banner_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/home_products/home_products_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/banner_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/category.horizontal.listview.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/common/product.horizontal.listview.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

import 'components/categories.banner.grid.component.dart';
import 'components/home.products.grid.component.dart';

enum WidgetStatus { idle, loaded, loading, error }

class HomeTabPage extends StatefulWidget {
  final ProductBloc featuredBloc;
  final ProductBloc latestBloc;
  final ProductBloc onSaleBloc;

  const HomeTabPage({
    Key key,
    @required this.featuredBloc,
    @required this.latestBloc,
    @required this.onSaleBloc,
  }) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin<HomeTabPage> {
  // Banners variables
  bool isBannerLoading = false;
  List<List<BannerModel>> banners = [];
  Map<String, Null> wishListMaper = {};

  // Home products variables
  WidgetStatus homeProductsWidgetStatus = WidgetStatus.idle;
  String homeProductsWidgetErrorMessage = "";
  List<ProductModel> apiProducts;
  List<ProductModel> apiInfiniteProducts;
  WidgetStatus homeInfiniteProductsWidgetStatus = WidgetStatus.idle;
  String homeInfiniteProductsWidgetErrorMessage = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;

    BlocProvider.of<BannerBloc>(context).add(GetBannerEvent());
    BlocProvider.of<HomeProductsBloc>(context).add(GetHomeProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: CustomAppBar(
          text: AppLocalizations.of(context).translate("home", defaultText: "Home"),
        ),
        body: BlocListener<BannerBloc, BannerState>(
          listener: (BuildContext context, BannerState state) {
            print("--------------------");
            print(state.runtimeType);
            print("--------------------");
            if (state is BannerLoadingState) {
              setState(() {
                isBannerLoading = true;
              });
            } else if (state is BannerLoadedState) {
              setState(() {
                if (state.banners is List && state.banners.length > 0) {
                  var len = state.banners.length;
                  var chunkSize = 5;
                  for (var i = 0; i < len; i += chunkSize) {
                    var end = (i + chunkSize < len) ? i + chunkSize : len;
                    banners.add(state.banners.sublist(i, end));
                  }
                }
                isBannerLoading = false;
              });
            } else if (state is BannerErrorState) {
              setState(() {
                isBannerLoading = false;
              });
            }
          },
          child: LoadAny(
            onLoadMore: () {
              BlocProvider.of<HomeProductsBloc>(context).add(GetHomeProductsEvent(isLoadMoreMode: true, perPage: 20));
              return null;
            },
            status: LoadStatus.normal,
            loadingMsg: 'Loading...',
            child: CustomScrollView(
              slivers: <Widget>[
                //Categories
                SliverToBoxAdapter(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoadedState) {
                        return CategoryHorizontalListViewComponent(
                          categories: state.nestedCategories,
                        );
                      } else if (state is CategoryLoadingState) {
                        return Center(
                          child: LoadingWidget(
                            size: 40,
                          ),
                        );
                      } else if (state is CategoryErrorState) {
                        return GenericState(
                          size: 40,
                          margin: 8,
                          fontSize: 16,
                          removeButton: true,
                          imagePath: Constants.imagePath["error"],
                          titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
                          bodyKey: state.message,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                // Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                // First banner
                isBannerLoading
                    ? SliverToBoxAdapter(
                        child: LoadingWidget(
                        size: 30,
                      ))
                    : SliverToBoxAdapter(
                        child: CategoriesBannerGridComponent(
                        banners: banners.length > 0 ? banners[0] : [],
                      )),
                //Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                // Featured
                SliverToBoxAdapter(
                    child: HomeProductDisplayComponent(
                  labelKey: "FEATURED",
                  productBloc: widget.featuredBloc,
                )),
                // Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                      height: AppDimens.marginSeparator16,
                    )),
                // For you
                BlocListener<HomeProductsBloc, HomeProductsState>(
                  listener: (BuildContext context, HomeProductsState state) {
                    if (state is HomeProductsLoadingState) {
                      setState(() {
                        if (state.isLoadMoreMode) {
                          homeInfiniteProductsWidgetStatus = WidgetStatus.loading;
                        } else {
                          homeProductsWidgetStatus = WidgetStatus.loading;
                        }
                      });
                    } else if (state is HomeProductsLoadedState) {
                      setState(() {
                        if (state.isLoadMoreMode) {
                          if (apiInfiniteProducts == null) apiInfiniteProducts = new List();
                          apiInfiniteProducts.addAll(state.products);
                          homeInfiniteProductsWidgetStatus = WidgetStatus.loaded;
                        } else {
                          apiProducts = state.products;
                          homeProductsWidgetStatus = WidgetStatus.loaded;
                          BlocProvider.of<HomeProductsBloc>(context).add(GetHomeProductsEvent(isLoadMoreMode: true, perPage: 20));
                        }
                      });
                    } else if (state is HomeProductsErrorState) {
                      setState(() {
                        if (state.isLoadMoreMode) {
                          homeInfiniteProductsWidgetStatus = WidgetStatus.error;
                          homeInfiniteProductsWidgetErrorMessage = state.message;
                        } else {
                          homeProductsWidgetStatus = WidgetStatus.error;
                          homeProductsWidgetErrorMessage = state.message;
                        }
                      });
                    }
                  },
                  child: SliverToBoxAdapter(
                    child: HomeApiProductDisplayComponent(
                      products: apiProducts,
                      status: homeProductsWidgetStatus,
                      labelKey: AppLocalizations.of(context).translate("for_you", defaultText: "FOR YOU"),
                      errorMessage: homeProductsWidgetErrorMessage,
                    ),
                  ),
                ),
                //Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                // Latest
                SliverToBoxAdapter(
                  child: HomeProductDisplayComponent(
                    labelKey: "LATEST",
                    productBloc: widget.latestBloc,
                  ),
                ),
                //Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                // Second banner
                isBannerLoading
                    ? SliverToBoxAdapter(child: Container())
                    : SliverToBoxAdapter(
                        child: CategoriesBannerGridComponent(
                          banners: banners.length > 1 ? banners[1] : [],
                        ),
                      ),
                //Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                // On sale
                SliverToBoxAdapter(
                  child: HomeProductDisplayComponent(
                    labelKey: "onSale",
                    productBloc: widget.onSaleBloc,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 8),
                      child: Text(
                  AppLocalizations.of(context).translate("more", defaultText: "More"),
                  style: Theme.of(context).textTheme.headline1,
                ),
                    )),
                // Other banners
                SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (banners != null) {
                        List<Widget> list = new List();
                        for (var i = 0; i < banners.length; i++) {
                          if (i != 0 && i != 1) {
                            list.add(CategoriesBannerGridComponent(
                              banners: banners[i] != null ? banners[i] : [],
                            ));
                          }
                        }
                        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: list);
                      }
                      return Container();
                    },
                  ),
                ),
                //Divider
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: AppDimens.marginSeparator16,
                )),
                (apiInfiniteProducts != null)
                    ? SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        itemCount: apiInfiniteProducts.length + 1,
                        crossAxisSpacing: AppDimens.marginDefault8,
                        mainAxisSpacing: AppDimens.marginDefault8,
                        staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.35),
                        itemBuilder: (BuildContext context, int index) {
                          if (index < apiInfiniteProducts.length) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(start: (index.isEven) ? 8 : 0, end: (index.isEven) ? 0 : 8),
                              child: ProductCardComponent(
                                product: apiInfiniteProducts[index],
                                onItemTap: () => Navigator.pushNamed(
                                  context,
                                  Constants.productDetailsPage,
                                  arguments: apiInfiniteProducts[index],
                                ),
                                variationId: apiInfiniteProducts[index].defaultVariationId,
                                attribute: apiInfiniteProducts[index].defaultAttributes,
                                inInFav: wishListMaper.containsKey(apiInfiniteProducts[index].id.toString() +
                                        apiInfiniteProducts[index].defaultVariationId.toString()) ??
                                    false,
                                imageHeight: 170,
                                allowMargin: false,
                              ),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.all(15),
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    backgroundColor: AppColors.primaryColors[400],
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : SliverToBoxAdapter(child: Container())
              ],
            ),
          ),
        ));
  }
}

class HomeProductDisplayComponent extends StatelessWidget {
  final String labelKey;
  final ProductBloc productBloc;
  const HomeProductDisplayComponent({
    Key key,
    @required this.labelKey,
    @required this.productBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ProductBloc, ProductState>(
        cubit: productBloc,
        builder: (context, state) {
          if (state is ProductsLoadedState) {
            if (state.products != null && state.products.length > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.marginDefault12, vertical: AppDimens.marginDefault8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate(labelKey, defaultText: labelKey),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  ),
                  ProductHorizontalListView(
                    products: state.products,
                  )
                ],
              );
            } else {
              return Container();
            }
          } else if (state is ProductsLoadingState) {
            return Center(
              child: LoadingWidget(
                size: 40,
              ),
            );
          } else if (state is ProductsErrorState) {
            return GenericState(
              size: 40,
              margin: 8,
              fontSize: 16,
              removeButton: true,
              imagePath: Constants.imagePath["error"],
              titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
              bodyKey: state.message,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class HomeApiProductDisplayComponent extends StatelessWidget {
  final String labelKey;
  final String errorMessage;
  final List<ProductModel> products;
  final WidgetStatus status;

  const HomeApiProductDisplayComponent({
    Key key,
    @required this.labelKey,
    @required this.products,
    @required this.status,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (status == WidgetStatus.idle) {
            return Container();
          } else if (status == WidgetStatus.loading) {
            return Center(
              child: LoadingWidget(
                size: 40,
              ),
            );
          } else if (status == WidgetStatus.error) {
            return GenericState(
              size: 40,
              margin: 8,
              fontSize: 16,
              removeButton: true,
              imagePath: Constants.imagePath["error"],
              titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
              bodyKey: errorMessage != null ? errorMessage : AppLocalizations.of(context).translate("error_title"),
            );
          } else if (status == WidgetStatus.loaded && products != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.marginDefault12, vertical: AppDimens.marginDefault8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        labelKey != null ? AppLocalizations.of(context).translate(labelKey, defaultText: labelKey) : "",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                ),
                HomeProductsGridComponent(
                  products: products,
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
