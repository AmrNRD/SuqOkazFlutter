import 'package:flutter/material.dart';
import 'package:suqokaz/ui/modules/home/home.tab.dart';
import 'package:suqokaz/ui/modules/navigation/home.navigation.dart';
import 'package:suqokaz/ui/modules/splash/splash.page.dart';
import 'constants.dart';

class RouteGenerator {

  RouteGenerator();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Constants.mainScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.mainScreen),
          builder: (_) => LandingSplashScreen(),
        );
      case Constants.categoriesScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.categoriesScreen),
          builder: (_) => LandingSplashScreen(),
        );
      case Constants.homeScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: Constants.homeScreen),
          builder: (_) => HomeNavigationPage(),
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
