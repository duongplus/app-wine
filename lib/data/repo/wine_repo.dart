import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wine_app/data/remote/wine_service.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';

class WineRepo {
  WineService _wineService;

  WineRepo({@required WineService wineService})
      : this._wineService = wineService;

  Future<List<Cate>> getWineCategories() async {
    var c = Completer<List<Cate>>();
    try {
      var response = await _wineService.getWineList();
      var cateList = Cate.parseCateList(response.data);
      c.complete(cateList);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<Wine>> getWineByCateId(String cateId) async {
    var c = Completer<List<Wine>>();
    try{
      var response = await _wineService.getWinesByCateId(cateId);
      print(response.data);
      var wineList = Wine.parseWineList(response.data);
      print(wineList.length);
      c.complete(wineList);
    } on DioError {

    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }

  Future<UserData> profileUser() async {
    Completer c = Completer<UserData>();
    try {
      var response =
      await _wineService.profileUser();
      var userData = UserData.fromJson(response.data['data']);
      c.complete(userData);
    } on DioError catch (e) {
      //TODO: Loi network
      c.completeError(e.response.data);
    } catch (e) {
      //TODO:
      c.completeError(e);
    }
    return c.future;
  }

  Future<int> updateWine(Wine wine) async {
    Completer c = Completer<int>();
    try {
      var response =
      await _wineService.updateWine(wine);
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

  Future<int> addWine(Wine wine) async {
    Completer c = Completer<int>();
    try {
      var response =
      await _wineService.addWine(wine);
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
}
