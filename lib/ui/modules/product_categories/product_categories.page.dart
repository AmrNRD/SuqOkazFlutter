import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.gridview.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductCategoriesPage extends StatefulWidget {
  final String appBarTitle;
  final int parentId;
  final List<CategoryModel> subCategories;
  final int selectedSubCategoryId;

  const ProductCategoriesPage({
    Key key,
    @required this.appBarTitle,
    @required this.subCategories,
    @required this.parentId,
    this.selectedSubCategoryId = 0,
  }) : super(key: key);

  @override
  _ProductCategoriesPageState createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = [];
  List<Widget> tabBarView = [];
  bool isFirstTime = true;
  int selectedSubCategory = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isFirstTime = false;
      createSubCategoryTabs();
      createTabBarView();
      print(selectedSubCategory);
      setState(() {
        _tabController = TabController(
          vsync: this,
          length: widget.subCategories.length + 1,
          initialIndex: selectedSubCategory,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        canPop: true,
        text: widget.appBarTitle ?? "",
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 16),
            height: screenAwareSize(30, context),
            width: double.infinity,
            child: (_tabController != null)
                ? (_tabController.length == 0)
                    ? Container()
                    : TabBar(
                        tabs: tabs,
                        labelPadding: EdgeInsets.symmetric(horizontal: 4),
                        indicatorPadding: EdgeInsets.zero,
                        controller: _tabController,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.customGreyLevels[50],
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppColors.primaryColors[50],
                        ),
                      )
                : Container(),
          ),
          Expanded(
            child: Container(
              child: ((_tabController != null)
                  ? (_tabController.length == 0)
                      ? LoadingWidget()
                      : TabBarView(
                          controller: _tabController,
                          children: [...tabBarView],
                        )
                  : LoadingWidget()),
            ),
          ),
        ],
      ),
    );
  }

  createSubCategoryTabs() {
    tabs.add(
      Tab(
        child: Container(
          padding:
              EdgeInsetsDirectional.only(start: 12, end: 12, top: 2, bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primaryColors[50], width: 0.2),
          ),
          child: Text(
            AppLocalizations.of(context).translate("all_categories"),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    for (int i = 0; i < widget.subCategories.length; i++) {
      tabs.add(
        Tab(
          child: Container(
            padding: EdgeInsetsDirectional.only(
                start: 12, end: 12, top: 2, bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: AppColors.primaryColors[50], width: 0.2),
            ),
            child: Text(
              widget.subCategories[i].name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  String orderBy;
  String order;

  createTabBarView() {
    tabBarView.add(
      ProductGridViewComponent(
        categoryId: widget.parentId,
        order: order,
        orderBy: orderBy,
      ),
    );

    for (int i = 0; i < widget.subCategories.length; i++) {
      print(widget.subCategories[i].name);
      print(widget.subCategories[i].id);
      print(widget.selectedSubCategoryId);
      if (widget.selectedSubCategoryId == widget.subCategories[i].id) {
        selectedSubCategory = i + 1;
      }
      tabBarView.add(
        ProductGridViewComponent(
          categoryId: widget.subCategories[i].id,
          order: order,
          orderBy: orderBy,
        ),
      );
    }
  }
}
