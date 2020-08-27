import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/category.horizontal.listview.component.dart';
import 'package:suqokaz/ui/common/product.horizontal.listview.component.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';

import 'components/categories.banner.grid.component.dart';


class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      margin: EdgeInsetsDirectional.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CategoryHorizontalListView(),
            SizedBox(height: AppDimens.marginSeparator16,),
            ProductHorizontalListView(),
            CategoriesBannerGridComponent(),
          ],
        ),
      ),
    ));
  }


}
