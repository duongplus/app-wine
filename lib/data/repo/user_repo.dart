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

  Future<UserData> signUp(String displayName, String phone, String pass,
      {String avatar}) async {
    Completer c = Completer<UserData>();
    try {
      var response =
          await _userService.signUp(displayName, phone, pass, avatar: avatar);
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

  Future<int> changeName(String displayName,) async {
    Completer c = Completer<int>();
    try {
      var response = await _userService.changeDisplayName(displayName);
      var status = response.data['status'];
      c.complete(status);
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data);
    } catch (e) {
      //TODO:
      c.completeError(e);
    }
    return c.future;
  }

  Future<int> changePassword(String password, String newPass) async {
    Completer c = Completer<int>();
    try {
      var response = await _userService.changePass(password, newPass);
      var status = response.data['status'];
      c.complete(status);
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data['status']);
    } catch (e) {
      //TODO:
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<UserData>> findAllUser() async {
    Completer c = Completer<List<UserData>>();
    try {
      var response = await _userService.findAllUser();
      var list = UserData.parseUserList(response.data['data']);
      c.complete(list);
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data['data'].toString());
      print(e);
    } catch (e) {
      //TODO:
      c.completeError(e.toString());
      print(e);
    }
    return c.future;
  }

  Future<int> passwordRecovery(String phone) async {
    Completer c = Completer<int>();
    try {
      var response = await _userService.passwordRecovery(phone);
      var status = response.data['status'];
      c.complete(status);
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data['status']);
    } catch (e) {
      //TODO:
      c.completeError(e);
    }
    return c.future;
  }
}
