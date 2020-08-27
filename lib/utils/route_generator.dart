import 'package:flutter/material.dart';
import 'package:suqokaz/ui/modules/address/address.page.dart';
import 'package:suqokaz/ui/modules/auth/auth.page.dart';
import 'package:suqokaz/ui/modules/home/home.tab.dart';
import 'package:suqokaz/ui/modules/navigation/home.navigation.dart';
import 'package:suqokaz/ui/modules/orders/orders.page.dart';
import 'package:suqokaz/ui/modules/splash/splash.page.dart';
import 'constants.dart';

class RouteGenerator {

  RouteGenerator();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
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
      case Constants.categoriesPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.categoriesPage),
          builder: (_) => LandingSplashScreen(),
        );
      case Constants.homePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.homePage),
          builder: (_) => HomeNavigationPage(),
        );
      case Constants.myOrderPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.myOrderPage),
          builder: (_) => MyOrdersPage(),
        );
      case Constants.addressesPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.addressesPage),
          builder: (_) => AddressesPage(),
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
