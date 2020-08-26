import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/ui/modules/home/home.tab.dart';
import 'package:suqokaz/ui/modules/profile/profile.page.dart';

import '../../../utils/app.localization.dart';
import '../home/home.tab.dart';

class HomeNavigationPage extends StatefulWidget {
  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
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

  List<Widget> body = [
    HomeTabPage(),
    Container(),
    Container(),
    ProfilePage(),
  ];
  int _currentSelectedTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentSelectedTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentSelectedTab == 0
                  ? "assets/icons/home_selected_icon.svg"
                  : "assets/icons/home_icon.svg",
            ),
            title: Text(
              AppLocalizations.of(context)
                  .translate("todo", defaultText: "Home"),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentSelectedTab == 1
                  ? "assets/icons/heart_selected_icon.svg"
                  : "assets/icons/heart_icon.svg",
            ),
            title: Text(
              AppLocalizations.of(context)
                  .translate("todo", defaultText: "Wish List"),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentSelectedTab == 2
                  ? "assets/icons/shopping_selected_icon.svg"
                  : "assets/icons/shopping_icon.svg",
            ),
            title: Text(
              AppLocalizations.of(context)
                  .translate("todo", defaultText: "Cart"),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentSelectedTab == 3
                  ? "assets/icons/user_selected_icon.svg"
                  : "assets/icons/user_icon.svg",
            ),
            title: Text(
              AppLocalizations.of(context)
                  .translate("Home", defaultText: "Profile"),
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentSelectedTab,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
