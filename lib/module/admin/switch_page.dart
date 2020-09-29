import 'package:flutter/material.dart';
import 'package:wine_app/module/admin/admin_home_page.dart';

class SwitchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: 400,
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              Image.asset(
                'assets/img/wine_logo.png',
                width: 200,
                height: 200,
              ),
              ListTile(
                title: Text(
                  'Chào mừng người quản trị.\n Mời bạn chọn trang muốn tới',
                  style: TextStyle(fontSize: 16, color: Colors.brown[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomePage(),
                      ));
                },
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Trang quản trị".toUpperCase(),
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Trang chủ".toUpperCase(),
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
