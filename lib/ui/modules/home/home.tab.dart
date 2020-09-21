import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/banner/banner_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/data/models/banner_model.dart';
import 'package:suqokaz/ui/common/category.horizontal.listview.component.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.horizontal.listview.component.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

import 'components/categories.banner.grid.component.dart';

class HomeTabPage extends StatefulWidget {
  final ProductBloc featuredBloc;
  final ProductBloc latestBloc;

  const HomeTabPage({
    Key key,
    @required this.featuredBloc,
    @required this.latestBloc,
  }) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  bool isBannerLoading = false;
  List<BannerModel> banners = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerBloc>(context).add(GetBannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24),
        child: BlocListener<BannerBloc, BannerState>(
          listener: (BuildContext context, BannerState state) {
            if (state is BannerLoadingState) {
              setState(() {
                isBannerLoading = true;
              });
            } else if (state is BannerLoadedState) {
              setState(() {
                banners = state.banners;
                isBannerLoading = false;
              });
            } else if (state is BannerErrorState) {
              setState(() {
                isBannerLoading = false;
              });
            }
          },
          child: Column(
            children: <Widget>[
              BlocBuilder<CategoryBloc, CategoryState>(
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
              SizedBox(
                height: AppDimens.marginSeparator16,
              ),
              HomeProductDisplayComponent(
                labelKey: "FEATURED",
                productBloc: widget.featuredBloc,
              ),
              SizedBox(
                height: AppDimens.marginEdgeCase24,
              ),
              isBannerLoading
                  ? LoadingWidget(
                      size: 30,
                    )
                  : CategoriesBannerGridComponent(
                      banners: banners.length >= 5 ? banners?.sublist(0, 5) : [],
                    ),
              HomeProductDisplayComponent(
                labelKey: "LATEST",
                productBloc: widget.latestBloc,
              ),
              SizedBox(
                height: AppDimens.marginEdgeCase24,
              ),
              isBannerLoading
                  ? Container()
                  : CategoriesBannerGridComponent(
                      banners: banners.length > 5 ? banners?.sublist(5) : [],
                    ),
            ],
          ),
        ),
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.marginDefault16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate(labelKey, defaultText: labelKey),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            cubit: productBloc,
            builder: (context, state) {
              if (state is ProductsLoadedState) {
                return ProductHorizontalListView(
                  products: state.products,
                );
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
        ],
      ),
    );
  }
}
