import 'package:flutter/material.dart';
import 'package:wine_app/shared/app_color.dart';
import 'module/home/home_page.dart';
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
        theme: ThemeData(
          primarySwatch: AppColor.yellow,
        ),
        title: "wine app",
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => SignInPage(),
          '/home': (context) => HomePage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
        },
      ),
    );
  }
}
