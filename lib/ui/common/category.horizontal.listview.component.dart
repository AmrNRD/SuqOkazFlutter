import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';

class CategoryHorizontalListView extends StatefulWidget {
  final int selectedCategory;

  const CategoryHorizontalListView({
    Key key,
    this.selectedCategory,
  }) : super(key: key);

  @override
  _CategoryHorizontalListViewState createState() =>
      _CategoryHorizontalListViewState();
}

class _CategoryHorizontalListViewState
    extends State<CategoryHorizontalListView> {

  bool isHomeScreenCall = false;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
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
        itemCount: 6,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsetsDirectional.only(start: 8),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  color: generateRandomColor(index),
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: InkWell(
                    radius: 16,
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12, horizontal: AppDimens.marginDefault12),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            "assets/images/dummy_phone.png",
                            fit: BoxFit.contain,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "PHONES",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color generateRandomColor(int index) {
    return AppColors.randomColors[index % 9];
  }
}
