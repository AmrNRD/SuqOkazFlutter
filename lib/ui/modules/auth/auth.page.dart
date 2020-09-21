import 'package:flutter/material.dart';

import 'components/login_screen.component.dart';
import 'components/register_screen.component.dart';
import 'components/reset_password_screen.component.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  @override
  void initState() {
    tabController=new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            // RestPasswordScreen(goToSignIn: ()=>goToPage(1)),
            LoginScreen(goToSignUp:()=>goToPage(1),goToForgotPassword:()=>goToPage(0)),
            RegisterScreen(goToSignIn: ()=>goToPage(0)),
          ],
        ),
      ),
    );
  }

  void goToPage(int page){
    tabController.animateTo(page);
  }
}
