import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductHorizontalListView extends StatefulWidget {
  final int selectedCategory;

  const ProductHorizontalListView({
    Key key,
    this.selectedCategory,
  }) : super(key: key);

  @override
  _ProductHorizontalListViewState createState() =>
      _ProductHorizontalListViewState();
}

class _ProductHorizontalListViewState extends State<ProductHorizontalListView> {
  bool isHomeScreenCall = false;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
      suggestedRowHeight: 200,
    );
  }

  AutoScrollController _scrollController;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppDimens.marginDefault16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)
                    .translate("featured_products", defaultText: "FEATURED"),
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
        Container(
          height: 185,
          margin: EdgeInsetsDirectional.only(top: AppDimens.marginDefault16),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 6,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsetsDirectional.only(
                start: AppDimens.marginDefault16,
                end: AppDimens.marginDefault16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return ProductCardComponent(null);
            },
          ),
        ),
      ],
    );
  }
}
