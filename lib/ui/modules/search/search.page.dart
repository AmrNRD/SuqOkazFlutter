import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/libraries/search_bar/flappy_search_bar.dart';
import 'package:suqokaz/libraries/search_bar/scaled_tile.dart';
import 'package:suqokaz/libraries/search_bar/search_bar_style.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/delayed_animation.dart';
import 'package:suqokaz/ui/common/filter.sheet.component.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/common/product.card.long.component.dart';
import 'package:suqokaz/ui/common/product.view.modification.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  // Repos
  ProductsRepository productsRepository = ProductsRepository();

  // Pagination
  int currentPage = 1;
  bool isSearching = false;
  String searchAbout = "";
  bool lastPageReached = false;
  bool showLoading = false;
  ScrollController listController = ScrollController();
  AnimationController _controller;

  // Data holder
  List<ProductModel> dataList = [];

  StreamSubscription<dynamic> dataListStream;
  String orderBy;
  String order;
  Future productsFuture;
  bool isList = false;

  @override
  void initState() {
    super.initState();
    searchBarController = SearchBarController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    productIdToCartItem = BlocProvider.of<CartBloc>(context).productIdToCartItem;
    listController.addListener(() {
      if (listController.position.pixels == listController.position.maxScrollExtent) {
        if (!lastPageReached) {
          setState(() {
            showLoading = true;
          });
          _loadNextSearch();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            listController.animateTo(
              listController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      }
    });
  }

  _loadNextSearch() async {
    await search(searchAbout);
  }

  void onSearchComplete() {
    setState(() {
      showLoading = false;
    });
  }

  void _showModalSheet({Function onExit}) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (builder) {
        return SafeArea(
          child: FilterSheet(
            onFilterChange: changeActiveFilter,
            orderBy: orderBy,
            order: order,
          ),
        );
      },
    );
  }

  changeActiveFilter(String _orderByParam, String _order) {
    if (_orderByParam != orderBy || _order != order) {
      setState(() {
        orderBy = _orderByParam;
        order = _order;
      });
      searchBarController.replayLastSearch();
    }
  }

  ScaledTile scaledTile = ScaledTile.count(1, 1.44);
  onChangeViewClick() {
    setState(() {
      isList = !isList;
      if (isList) {
        scaledTile = ScaledTile.count(2, 0.6);
      } else {
        scaledTile = ScaledTile.count(1, 1.44);
      }
    });
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Map<String, CartItem> productIdToCartItem = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate("search"),
        canPop: true,
        removeSearch: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          ProductViewModificationComponent(
            onViewChangeClick: onChangeViewClick,
            onSortClick: _showModalSheet,
          ),
          Expanded(
            child: BlocListener<CartBloc, CartState>(
              listener: (context, state) {
                if (state is CartLoadedState) {
                  setState(() {
                    productIdToCartItem = state.productIdToCartItem;
                  });
                } else if (state is CartErrorState) {
                  _globalKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      content: Text(
                        AppLocalizations.of(context).translate(state.message),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.red),
                      ),
                    ),
                  );
                }
              },
              child: searchScreen(),
            ),
          ),
          showLoading
              ? SafeArea(
                  child: LoadingWidget(
                    size: 40,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  SearchBarController<ProductModel> searchBarController;

  Future<List<ProductModel>> search(String search) async {
    if (!isSearching) {
      // Mark as searching
      setState(() {
        isSearching = true;
        searchAbout = search;
      });

      print("searching");

      // Search products
      Future<dynamic> productsFuture = productsRepository.getCustomizableProducts(
        lang: AppLocalizations.of(context).locale.toLanguageTag(),
        pageIndex: currentPage,
        perPage: 10,
        order: order,
        orderBy: orderBy,
        search: search,
      );
      productsFuture.then((value) => onSearchComplete());
      try {
        dataListStream = productsFuture.asStream().listen((productsList) {
          // Process data
          // Init data holder
          //if(currentPage == 1) dataList = List();
          // Loop on data
          for (var item in productsList) {
            if (!Constants.hideOutOfStock || item["in_stock"]) {
              var product = ProductModel.fromJson(item);
              dataList.add(product);
            }
          }

          // Go to next page
          currentPage++;

          // Check last page
          if (productsList.isEmpty) lastPageReached = true;

          // Searching finished
          setState(() {
            isSearching = false;
          });
        });
      } catch (e) {
        throw Exception(AppLocalizations.of(context).translate("error_title"));
      }
    }
    return dataList;
  }

  Widget searchScreen() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: SearchBar<ProductModel>(
          scrollController: listController,
          listItemsCount: dataList.length,
          dataList: dataList,
          forceLoading: (isSearching && currentPage == 1),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          searchBarPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          cancellationWidget: Text(
            AppLocalizations.of(context).translate("cancel"),
          ),
          icon: Container(
            margin: EdgeInsetsDirectional.only(start: 14),
            child: SvgPicture.asset(
              "assets/icons/search_icon.svg",
            ),
          ),
          iconActiveColor: AppColors.customGreyLevels[200].withOpacity(0.6),
          searchBarStyle: SearchBarStyle(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onSearch: (value) {
            isSearching = false;
            lastPageReached = false;
            currentPage = 1;
            dataList = List();
            if (dataListStream != null) dataListStream.cancel();
            return search(value);
          },
          listPadding: EdgeInsetsDirectional.only(
            start: AppDimens.marginDefault16,
            end: AppDimens.marginDefault16,
            bottom: AppDimens.marginDefault16,
          ),
          indexedScaledTileBuilder: (int index) => scaledTile,
          searchBarController: searchBarController,
          placeHolder: Center(
            child: GenericState(
              imagePath: Constants.imagePath["search_magnifier"],
              titleKey: "search_product_title",
              titleStyle: Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 24,
                    color: AppColors.customGreyLevels[200],
                  ),
              bodyStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Color(0xFF979797),
                    fontWeight: FontWeight.w100,
                  ),
              bodyKey: "search_product_body",
              removeButton: true,
            ),
          ),
          emptyWidget: Center(
            child: GenericState(
              imagePath: Constants.imagePath["empty_box"],
              titleKey: "no_result_title",
              bodyKey: "no_result_body",
              removeButton: true,
            ),
          ),
          onItemFound: (ProductModel productData, int index) {
            return isList
                ? ProductCardLongComponent(
                    product: productData,
                    variationId: productData.defaultVariationId,
                    isInCart: productIdToCartItem
                            .containsKey(productData.id.toString() + productData.defaultVariationId.toString()) ??
                        false,
                    onItemTap: () {
                      Navigator.pushNamed(
                        context,
                        Constants.productDetailsPage,
                        arguments: productData,
                      );
                    },
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ProductCardComponent(
                      product: productData,
                      allowMargin: false,
                      variationId: productData.defaultVariationId,
                      isInCart: productIdToCartItem
                              .containsKey(productData.id.toString() + productData.defaultVariationId.toString()) ??
                          false,
                      onItemTap: () {
                        Navigator.pushNamed(
                          context,
                          Constants.productDetailsPage,
                          arguments: productData,
                        );
                      },
                    ),
                  );
          },
          onError: (_) {
            return Center(
              child: GenericState(
                imagePath: Constants.imagePath["error"],
                titleKey: AppLocalizations.of(context).translate("error_title"), //TODO : translate
                bodyKey: "Please try again.",
                removeButton: true,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    if (dataListStream != null) dataListStream.cancel();
  }
}
