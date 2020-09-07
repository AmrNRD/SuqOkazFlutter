import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/category.bubble.component.dart';

class CategoryHorizontalListViewComponent extends StatefulWidget {
  final int selectedCategory;
  final List<dynamic> categories;

  const CategoryHorizontalListViewComponent({
    Key key,
    this.selectedCategory,
    @required this.categories,
  }) : super(key: key);

  @override
  _CategoryHorizontalListViewComponentState createState() =>
      _CategoryHorizontalListViewComponentState();
}

class _CategoryHorizontalListViewComponentState
    extends State<CategoryHorizontalListViewComponent> {
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

  Map<int, CartItem> productIdToCartItem = {};

  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.categories.length,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return CategoryBubbleComponent(
            category: widget.categories[index],
            index: index,
          );
        },
      ),
    );
  }
}
