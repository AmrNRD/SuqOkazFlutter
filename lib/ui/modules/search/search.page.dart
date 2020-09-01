import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/libraries/search_bar/flappy_search_bar.dart';
import 'package:suqokaz/libraries/search_bar/scaled_tile.dart';
import 'package:suqokaz/libraries/search_bar/search_bar_style.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/delayed_animation.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Repos
  ProductsRepository productsRepository = ProductsRepository();

  // Pagination
  int currentPage = 1;
  bool isSearching = false;
  String searchAbout = "";
  bool lastPageReached = false;
  bool showLoading = false;
  ScrollController listController = ScrollController();

  // Data holder
  List<ProductModel> dataList = [];

  StreamSubscription<dynamic> dataListStream;

  Future productsFuture;

  @override
  void initState() {
    super.initState();
    searchBarController = SearchBarController();
    listController.addListener(() {
      if (listController.position.pixels ==
          listController.position.maxScrollExtent) {
        setState(() {
          showLoading = true;
        });
        _loadNextSearch();
      }
    });
  }

  _loadNextSearch() async {
    await search(searchAbout);
  }

  void onSearchComplete() {
    print("done");
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: AppLocalizations.of(context).translate("search"),
        canPop: true,
        removeSearch: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: searchScreen(),
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
      Future<dynamic> productsFuture =
          productsRepository.getCustomizableProducts(
        lang: AppLocalizations.of(context).locale.toLanguageTag(),
        pageIndex: currentPage,
        perPage: 10,
        search: search,
      );
      productsFuture.then((value) => onSearchComplete());
      dataListStream = productsFuture.asStream().listen((productsList) {
        // Process data
        if (productsList is List) {
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
        } else {
          // Throw error
          throw Exception("Error occurred");
        }
      });
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
          indexedScaledTileBuilder: (int index) => ScaledTile.count(1, 1.3),
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
            return DelayedAnimation(
              delay: 500,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: AppDimens.marginDefault16,
                ),
                child: ProductCardComponent(
                  product: dataList[index],
                ),
              ),
            );
          },
          onError: (_) {
            return Center(
              child: GenericState(
                imagePath: Constants.imagePath["error"],
                titleKey: "Error occurred", //TODO : translate
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
    if (dataListStream != null) dataListStream.cancel();
  }
}
