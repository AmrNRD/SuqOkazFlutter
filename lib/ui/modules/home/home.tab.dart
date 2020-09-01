import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/ui/common/category.horizontal.listview.component.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.horizontal.listview.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

import 'components/categories.banner.grid.component.dart';

class HomeTabPage extends StatelessWidget {
  final ProductBloc featuredBloc;
  final ProductBloc latestBloc;

  const HomeTabPage({
    Key key,
    @required this.featuredBloc,
    @required this.latestBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24),
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
                    //TODO: Translate
                    titleKey: AppLocalizations.of(context)
                        .translate("todo", defaultText: "Sad Error Title :("),
                    bodyKey: AppLocalizations.of(context).translate(
                      "todo",
                      defaultText: state.message,
                    ),
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
              productBloc: featuredBloc,
            ),
            SizedBox(
              height: AppDimens.marginDefault12,
            ),
            CategoriesBannerGridComponent(),
            HomeProductDisplayComponent(
              labelKey: "LATEST",
              productBloc: latestBloc,
            ),
            CategoriesBannerGridComponent(),
          ],
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
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: AppDimens.marginDefault16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate(labelKey, defaultText: labelKey),
                  style: Theme.of(context).textTheme.headline2,
                ),
                GestureDetector(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("all_items", defaultText: "More"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: AppColors.primaryColors[50],
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {},
                )
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
                  //TODO: Translate
                  titleKey: AppLocalizations.of(context)
                      .translate("todo", defaultText: "Sad Error Title :("),
                  bodyKey: AppLocalizations.of(context).translate(
                    "todo",
                    defaultText: state.message,
                  ),
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
