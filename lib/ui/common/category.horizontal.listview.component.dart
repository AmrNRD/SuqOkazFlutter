import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/utils/core.util.dart';

class CategoryHorizontalListViewComponent extends StatefulWidget {
  final int selectedCategory;
  final List<CategoryModel> categories;

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

class CategoryBubbleComponent extends StatelessWidget {
  const CategoryBubbleComponent({
    Key key,
    @required this.category,
    @required this.index,
  }) : super(key: key);

  final CategoryModel category;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: index != 6 - 1 ? 18 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: generateRandomColor(index),
              boxShadow: [
                BoxShadow(
                  color: generateRandomColor(index),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: ImageProcessor.image(
                  url: category.image,
                  fit: BoxFit.cover,
                  height: 38,
                  width: 38,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            category.name,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w400, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
