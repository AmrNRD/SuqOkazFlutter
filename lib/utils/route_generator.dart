import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/address/address_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/data/repositories/address.repository.dart';
import 'package:suqokaz/data/repositories/categories.repository.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/main.dart';
import 'package:suqokaz/ui/modules/address/add_address.page.dart';
import 'package:suqokaz/ui/modules/address/address.page.dart';
import 'package:suqokaz/ui/modules/address/edit_address.page.dart';
import 'package:suqokaz/ui/modules/auth/auth.page.dart';
import 'package:suqokaz/ui/modules/category/category.page.dart';
import 'package:suqokaz/ui/modules/navigation/home.navigation.dart';
import 'package:suqokaz/ui/modules/orders/orders.page.dart';
import 'package:suqokaz/ui/modules/product_categories/product_categories.page.dart';
import 'package:suqokaz/ui/modules/product_details/product_details.page.dart';
import 'package:suqokaz/ui/modules/splash/splash.page.dart';
import 'constants.dart';

class RouteGenerator {
  RouteGenerator();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case Constants.mainPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.mainPage),
          builder: (_) => LandingSplashScreen(),
        );
      case Constants.authPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.authPage),
          builder: (_) => AuthPage(),
        );
      case Constants.productDetailsPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.productDetailsPage),
          builder: (_) => BlocProvider<ReviewBloc>(
            create: (BuildContext context) => ReviewBloc(
              ProductsRepository(),
            ),
            child: ProductDetailsPage(
              productModel: args,
            ),
          ),
        );
      case Constants.productCategoriesPage:
        if (args is List) {
          return MaterialPageRoute(
            settings: RouteSettings(name: Constants.productCategoriesPage),
            builder: (_) => BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(
                ProductsRepository(),
              ),
              child: ProductCategoriesPage(
                appBarTitle: args[0],
                subCategories: args[1],
                parentId: args[2],
                selectedSubCategoryId: args.length > 4 ? args[3] : 0,
              ),
            ),
          );
        }
        return _errorRoute();
      case Constants.categoryPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.categoryPage),
          builder: (_) => BlocProvider<CategoryBloc>(
            create: (BuildContext context) => CategoryBloc(
              CategoriesRepository(),
            ),
            child: CategoryPage(),
          ),
        );
      case Constants.homePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.homePage),
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>(
                create: (BuildContext context) => CategoryBloc(
                  CategoriesRepository(),
                ),
              ),
              BlocProvider<ProductBloc>(
                create: (BuildContext context) => ProductBloc(
                  ProductsRepository(),
                ),
              ),
            ],
            child: HomeNavigationPage(),
          ),
        );
      case Constants.myOrderPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.myOrderPage),
          builder: (_) => MyOrdersPage(),
        );
      case Constants.addAddressScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.addAddressScreen),
          builder: (_) => AddAddressPage(),
        );
      case Constants.editAddressScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.editAddressScreen),
          builder: (_) => EditAddressPage(
            addressModel: args,
          ),
        );
      case Constants.addressesPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.myOrderPage),
          builder: (_) => BlocProvider<AddressBloc>(
            create: (BuildContext context) => AddressBloc(
              AddressDataRepository(Root.appDataBase),
            ),
            child: AddressesPage(),
          ),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
