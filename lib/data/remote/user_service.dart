import 'dart:async';

import 'package:dio/dio.dart';
import 'package:wine_app/network/wine_client.dart';
import 'package:wine_app/shared/model/user_data.dart';

class UserService {
  Future<Response> signIn(String phone, String pass) {
    return WineClient.instance.dio.post(
      '/api/user/sign-in',
      data: {
        'phone': phone,
        'password': pass,
      },
    );
  }
}
