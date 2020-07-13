import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/spref/spref.dart';
import 'package:wine_app/shared/constant.dart';
import 'package:wine_app/shared/model/user_data.dart';

class UserRepo {
  UserService _userService;

  UserRepo({@required UserService userService}) : _userService = userService;

  Future<UserData> signIn(String phone, String pass) async {
    Completer c = Completer<UserData>();
    try {
      var response = await _userService.signIn(phone, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data);
    } catch (e) {
      //TODO:
      c.completeError(e);
    }
    return c.future;
  }
}
