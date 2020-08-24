import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:suqokaz/ui/modules/home/home.tab.dart';

class HomeNavigationPage extends StatefulWidget {
  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  int _currentSelectedTab = 0;

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
    return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: PageView(
              children: [
                HomeTabPage(),
                Text("asd"),
              ],
            )),
            Container(
              child: CustomNavigationBar(
                iconSize: 30.0,
                selectedColor: Color(0xff040307),
                strokeColor: Color(0x30040307),
                unSelectedColor: Color(0xffacacac),
                backgroundColor: Colors.white,
                items: [
                  CustomNavigationBarItem(
                    icon: Icons.home,
                  ),
                  CustomNavigationBarItem(
                    icon: Icons.shopping_cart,
                  ),
                  CustomNavigationBarItem(
                    icon: Icons.lightbulb_outline,
                  ),
                  CustomNavigationBarItem(
                    icon: Icons.search,
                  ),
                  CustomNavigationBarItem(
                    icon: Icons.account_circle,
                  ),
                ],
                currentIndex: _currentSelectedTab,
                onTap: (index) {
                  setState(() {
                    _currentSelectedTab = index;
                  });
                },
              ),
            )
          ],
        ));
  }
}
