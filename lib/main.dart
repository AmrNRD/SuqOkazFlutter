import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/bloc/user/user_bloc.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/data/repositories/cart.repository.dart';
import 'package:suqokaz/data/repositories/categories.repository.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/utils/constants.dart';

import 'app.dart';
import 'data/models/user_model.dart';
import 'data/repositories/user_repository.dart';
import 'ui/style/app.colors.dart';
import 'ui/style/app.fonts.dart';
import 'ui/style/theme.dart';
import 'utils/app.localization.dart';
import 'utils/core.util.dart';
import 'utils/route_generator.dart';

void main() => runApp(Root());

class Root extends StatefulWidget {
  // This widget is the root of your application.
  static String fontFamily;
  static Locale locale;
  static UserModel user;
  static AppDataBase appDataBase = AppDataBase();

  static void setLocale(BuildContext context, Locale newLocale) async {
    context.findAncestorStateOfType<_RootState>().changeLocale(newLocale);
  }

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();

    Root.fontFamily = AppFonts.fontRoboto;
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        if (locale != null) {
          Root.locale = locale;
        } else {
          Root.locale = Locale("en", "US");
        }
      });
    });
  }

  changeLocale(Locale newLocale) {
    setState(() {
      Root.locale = newLocale;
    });
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('languageCode') == null) {
      return null;
    }

    return Locale(prefs.getString('languageCode'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(UserDataRepository()),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(
            CartDataRepository(Root.appDataBase),
            ProductsRepository(),
          ),
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => CategoryBloc(
            CategoriesRepository(Root.appDataBase),
          ),
        ),
      ],
      child: BlocListener<UserBloc,UserState>(
        listener: (context,state){
          if(state is UserLoadedState)
           {
             print("a7mos");
             setState(() {
               Root.user=Root.user;
             });
           }
        },
        child: MaterialApp(
          title: Constants.appName,
          supportedLocales: application.supportedLocales(),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: child,
            );
          },
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            accentColor: AppColors.primaryColor1,
            textTheme: AppTheme.textTheme,
            fontFamily: Root.fontFamily,
            cursorColor: AppColors.primaryColors[50],
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: AppColors.primaryColors[50],
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderSide: BorderSide(
                  color: AppColors.customGreyLevels[200].withOpacity(0.6),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.customGreyLevels[100],
                  width: 0.3,
                ),
              ),
              errorStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 11,
                    color: Colors.red,
                  ),
            ),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          locale: Root.locale,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          onGenerateRoute: RouteGenerator().generateRoute,
        ),
      ),
    );
  }
}
