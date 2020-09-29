import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wine_app/data/spref/spref.dart';
import 'package:wine_app/module/admin/switch_page.dart';
import 'package:wine_app/shared/constant.dart';
import 'package:wine_app/shared/model/user_data.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startApp();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  _startApp() {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
        if (token != null) {
          if(parseJwt(token)['role'] == "ADMIN"){
            Navigator.pushReplacementNamed(context, '/switch');
            return;
          }
          Navigator.pushReplacementNamed(context, '/home');
          return;
        }
        Navigator.pushReplacementNamed(context, '/sign-in');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/img/wine_logo.png',
              width: 200,
              height: 200,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Cửa hàng rượu',
                style: TextStyle(fontSize: 30, color: Colors.brown[600]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
