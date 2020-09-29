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

  Future<Response> signUp(String displayName, String phone, String pass,
      {String avatar}) {
    return WineClient.instance.dio.post(
      '/api/user/sign-up',
      data: {
        'displayName': displayName,
        'phone': phone,
        'password': pass,
        'avatar': avatar,
      },
    );
  }

  Future<Response> changePass(String password, String newPass) {
    return WineClient.instance.dio.post(
      '/api/user/change-pass',
      data: {
        "password": password,
        "newPass": newPass,
      },
    );
  }

  Future<Response> changeDisplayName(String name) {
    return WineClient.instance.dio.post(
      '/api/user/change-name',
      data: {
        'name': name,
      },
    );
  }

  Future<Response> findAllUser() {
    return WineClient.instance.dio.get(
      '/api/user/all-user',
    );
  }
}
