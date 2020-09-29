import 'package:flutter/material.dart';
import 'package:wine_app/module/admin/switch_page.dart';
import 'package:wine_app/module/home/home_page.dart';
import 'package:wine_app/module/splash/splash.dart';
import 'package:wine_app/shared/app_color.dart';
import 'module/admin/admin_home_page.dart';
import 'module/home/main_container_page.dart';
import 'module/home/tabdemo.dart';
import 'module/signup/signup_page.dart';
import 'module/signin/signin_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
//        theme: ThemeData(
//          primarySwatch: Colors.white,
//        ),
        title: "wine app",
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => SplashPage(),
          '/switch': (context) => SwitchPage(),
          '/home': (context) => HomeContainerPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
        },
      ),
    );
  }
}
