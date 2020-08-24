import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/ui/common/category.horizontal.listview.component.dart';
import 'package:suqokaz/ui/common/helper_widgets.dart';
import 'package:suqokaz/ui/common/product.horizontal.listview.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

import 'components/categories.banner.grid.component.dart';


class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


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
