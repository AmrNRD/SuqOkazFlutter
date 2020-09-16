import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/modules/cart/cart.page.dart';
import 'package:suqokaz/ui/modules/home/home.tab.dart';
import 'package:suqokaz/ui/modules/profile/profile.page.dart';
import 'package:suqokaz/ui/modules/search/search.page.dart';
import 'package:suqokaz/ui/modules/wishlist/wishlist.page.dart';
import 'package:suqokaz/utils/constants.dart';

import '../../../main.dart';
import '../../../utils/app.localization.dart';
import '../home/home.tab.dart';

class HomeNavigationPage extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  static final ProductBloc _featuredProducts = ProductBloc(ProductsRepository());
  static final ProductBloc _latestProducts = ProductBloc(ProductsRepository());

  List<Widget> body = [
    HomeTabPage(
      featuredBloc: _featuredProducts,
      latestBloc: _latestProducts,
    ),
    WishlistPage(),
    CartPage(),
    ProfilePage(),
  ];
  final List<String> appBarTitle = [];
  List<BottomNavigationBarItem> items = [];
  @override
  initState() {
    super.initState();
    _featuredProducts
      ..add(
        GetProductsEvent(isLoadMoreMode: false, featured: true),
      );
    _latestProducts
      ..add(
        GetProductsEvent(
          isLoadMoreMode: false,
          orderBy: DateTime.now().year.toString(),
        ),
      );
    BlocProvider.of<CategoryBloc>(context).add(GetCategoriesEvent());

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      appBarTitle.add(
        AppLocalizations.of(context).translate("home", defaultText: "Home"),
      );
      if (Root.user != null) {
        appBarTitle.add(
          AppLocalizations.of(context).translate("wishlist", defaultText: "Wishlist"),
        );
        appBarTitle.add(
          AppLocalizations.of(context).translate(
            "cart",
            defaultText: "Cart",
          ),
        );
      } else {
        body = [
          HomeTabPage(featuredBloc: _featuredProducts, latestBloc: _latestProducts),
          ProfilePage(),
        ];
      }
      appBarTitle.add(AppLocalizations.of(context).translate("settings", defaultText: "settings"));

      setState(() {
        appBarTitle;
      });
    });
  }

  int _currentSelectedTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOutState) {
          Navigator.pushReplacementNamed(context, Constants.authPage);
        }
      },
      child: Scaffold(
        key: HomeNavigationPage.scaffoldKey,
        appBar: CustomAppBar(text: appBarTitle.length < 3 ? "" : appBarTitle[_currentSelectedTab]),
        body: body[_currentSelectedTab],
        bottomNavigationBar: BottomNavigationBar(
          items: Root.user != null
              ? [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _currentSelectedTab == 0 ? "assets/icons/home_selected_icon.svg" : "assets/icons/home_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("home", defaultText: "Home"),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _currentSelectedTab == 1
                          ? "assets/icons/heart_selected_icon.svg"
                          : "assets/icons/heart_nav_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("wishlist", defaultText: "Wish List"),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _currentSelectedTab == 2
                          ? "assets/icons/shopping_selected_icon.svg"
                          : "assets/icons/shopping_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("cart", defaultText: "Cart"),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      (_currentSelectedTab == 3 && Root.user != null) || (_currentSelectedTab == 1 && Root.user == null)
                          ? "assets/icons/user_selected_icon.svg"
                          : "assets/icons/user_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("settings", defaultText: "settings"),
                    ),
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _currentSelectedTab == 0 ? "assets/icons/home_selected_icon.svg" : "assets/icons/home_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("home", defaultText: "Home"),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      (_currentSelectedTab == 3 && Root.user != null) || (_currentSelectedTab == 1 && Root.user == null)
                          ? "assets/icons/user_selected_icon.svg"
                          : "assets/icons/user_icon.svg",
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("settings", defaultText: "settings"),
                    ),
                  ),
                ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentSelectedTab,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
