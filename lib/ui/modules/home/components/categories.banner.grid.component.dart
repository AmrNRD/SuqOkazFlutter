import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';

import 'category.banner.box.dart';
import 'category.banner.header.dart';

class CategoriesBannerGridComponent extends StatefulWidget {
  const CategoriesBannerGridComponent({Key key}) : super(key: key);
  @override
  _CategoriesBannerGridComponentState createState() =>
      _CategoriesBannerGridComponentState();
}

class _CategoriesBannerGridComponentState
    extends State<CategoriesBannerGridComponent>
    with AutomaticKeepAliveClientMixin<CategoriesBannerGridComponent> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return bodyBuilder();
  }

  bodyBuilder() {
    return SafeArea(
      child: ListView.builder(
          itemCount: 1,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                CategoryBannerHeader(),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppDimens.marginDefault16,
                    vertical: AppDimens.marginDefault8,
                  ),
                  child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppDimens.marginDefault8,
                    mainAxisSpacing: AppDimens.marginDefault12,
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(1, 0.4),
                    scrollDirection: Axis.vertical,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryBannerBox();
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
