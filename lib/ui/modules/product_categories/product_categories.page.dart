import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/filter.sheet.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.gridview.component.dart';
import 'package:suqokaz/ui/common/product.listview.component.dart';
import 'package:suqokaz/ui/common/product.view.modification.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductCategoriesPage extends StatefulWidget {
  final String appBarTitle;
  final int parentId;
  final List<dynamic> subCategories;
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

class _ProductCategoriesPageState extends State<ProductCategoriesPage> with TickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = [];
  List<Widget> tabBarView = [];
  List<ProductModel> products = [];
  bool isFirstTime = true;
  bool isList = false;
  int selectedSubCategory = 0;
  String orderBy;
  Map filterData = {};
  String order;

  int parentId;
  List<dynamic> subCategories;
  int selectedSubCategoryId;

  onChangeViewClick() {
    tabBarView.clear();
    setState(() {
      isList = !isList;
      createTabBarView(isList);
    });
  }

  void _showModalSheet({Function onExit}) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (builder) {
        return SafeArea(
          child: FilterSheet(
            onFilterChange: changeActiveSort,
            orderBy: orderBy,
            order: order,
          ),
        );
      },
    );
  }

  changeActiveSort(String _orderByParam, String _order) {
    if (_orderByParam != orderBy || _order != order) {
      setState(() {
        tabBarView.clear();
        _tabController = TabController(
          vsync: this,
          length: 0,
        );
      });
      orderBy = _orderByParam;
      order = _order;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          createTabBarView(isList);
          _tabController = TabController(
            vsync: this,
            length: widget.subCategories.length + 1,
            initialIndex: selectedSubCategory,
          );
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    parentId = widget.parentId;
    subCategories = widget.subCategories;
    selectedSubCategoryId = widget.selectedSubCategoryId;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isFirstTime = false;
      createSubCategoryTabs();
      createTabBarView(isList);
      print(selectedSubCategory);
      setState(() {
        _tabController = TabController(
          vsync: this,
          length: subCategories.length + 1,
          initialIndex: selectedSubCategory,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        canPop: true,
        text: widget.appBarTitle ?? "",
      ),
      body: Column(
        children: <Widget>[
          ProductViewModificationComponent(
            isListView: isList,
            onViewChangeClick: onChangeViewClick,
            onSortClick: _showModalSheet,
            onFilterViewClick: onFilterClick,
          ),
          subCategories.length == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.only(right: 16, left: 16, top: 16),
                  height: screenAwareSize(30, context),
                  width: double.infinity,
                  child: (_tabController != null)
                      ? (_tabController.length == 0)
                          ? Container()
                          : TabBar(
                              tabs: tabs,
                              labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                              indicatorPadding: EdgeInsets.symmetric(horizontal: 4),
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
    if (subCategories.isNotEmpty) {
      tabs.add(
        Tab(
          child: Container(
            margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 2, bottom: 2),
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
    } else {
      tabs.add(
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primaryColors[50], width: 0.2),
            ),
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 2, bottom: 2),
              child: Text(
                AppLocalizations.of(context).translate("all_categories"),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < subCategories.length; i++) {
      tabs.add(
        Tab(
          child: Container(
            padding: EdgeInsetsDirectional.only(start: 12, end: 12, top: 2, bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primaryColors[50], width: 0.2),
            ),
            child: Text(
              subCategories[i].name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  createTabBarView(bool isList) {
    tabBarView.add(
      isList
          ? ProductListViewComponent(
              categoryId: parentId,
              order: order,
              orderBy: orderBy,
              filterData: filterData,
              onProductsChange: (products) {
                setState(() {
                  this.products = products;
                });
              },
            )
          : ProductGridViewComponent(
              categoryId: parentId,
              order: order,
              orderBy: orderBy,
              filterData: filterData,
              onProductsChange: (products) {
                setState(() {
                  this.products = products;
                });
              },
            ),
    );

    for (int i = 0; i < subCategories.length; i++) {
      if (selectedSubCategoryId == subCategories[i].id) {
        selectedSubCategory = i + 1;
      }
      tabBarView.add(
        isList
            ? ProductListViewComponent(
                categoryId: widget.subCategories[i].id,
                order: order,
                orderBy: orderBy,
                filterData: filterData,
              )
            : ProductGridViewComponent(
                categoryId: subCategories[i].id,
                order: order,
                orderBy: orderBy,
                filterData: filterData,
              ),
      );
    }
  }

  onFilterClick() async {
    if(filterData==null)
      filterData={};

    filterData['category']=parentId;
    filterData['subCategories']=subCategories;
    filterData['subcategory']=selectedSubCategory;
    print('selectedSubCategoryId');
    print(selectedSubCategoryId);
    print(selectedSubCategoryId.runtimeType);
    print('selectedSubCategory');
    print(selectedSubCategory);
    print(selectedSubCategory.runtimeType);

    print('to the filter');
    print(filterData);
    var res = await Navigator.of(context).pushNamed(Constants.filterPage, arguments: filterData);
    print('out of the filter');
    print(res);
    Map results = res as Map;
    setState(() {
      if(filterData.containsKey("minPrice")){
        filterData = results;
      }if(filterData.containsKey('category')&&filterData['category']!=null) {
        parentId = filterData['category'];
        filterData = results;
      }if(filterData.containsKey('subCategories')&&filterData['subCategories']!=null)
        subCategories = filterData['subCategories'];
      if(filterData.containsKey('subcategory')&&filterData['subcategory']!=null)
      selectedSubCategoryId = filterData['subcategory'].id;
      if(filterData.containsKey('subcategory')&&filterData['subcategory']!=null)
        selectedSubCategory = filterData['subcategory'].id;
      tabs = [];
      tabBarView = [];
    });

    createSubCategoryTabs();
    createTabBarView(isList);
    setState(() {
      _tabController = TabController(
        vsync: this,
        length: subCategories.length + 1,
        initialIndex: selectedSubCategory,
      );
    });
  }
}
