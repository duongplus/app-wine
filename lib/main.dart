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
      //  theme: ThemeData(
      //    primarySwatch: Colors.pink,
      //    accentColor: Colors.pink,
      //    accentIconTheme: IconThemeData(color: Colors.pink),
      //    buttonColor: Colors.pink,
      //    iconTheme: IconThemeData(color: Colors.pink),
      //  ),
        title: "wine app",
        // home: SignInPage(),
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
