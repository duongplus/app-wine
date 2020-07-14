import 'package:flutter/material.dart';
import 'module/signup/signup_page.dart';
import 'module/signin/signin_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "wine app",
      home: SignUpPage(),
    );
  }
}

