import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wine_app/data/remote/order_service.dart';
import 'package:wine_app/shared/model/revenue.dart';
import 'package:wine_app/shared/model/shopping_cart.dart';

class OrderRepo {
  OrderService _orderService;

  OrderRepo({@required OrderService orderService})
      : this._orderService = orderService;

  Future<int> getShoppingCartInfo() async {
    var c = Completer<int>();
    try {
      var response = await _orderService.countShoppingCart();
      var total = response.data['data'];
      c.complete(total);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<ShoppingCart>> getShoppingCart() async {
    var c = Completer<List<ShoppingCart>>();
    try {
      var response = await _orderService.getShoppingCart();
      print(response.data["wines"]);
      var shoppingCartList = ShoppingCart.parseShoppingCartList(response.data);
      c.complete(shoppingCartList);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<int> addToCart(String oid) async {
    var c = Completer<int>();
    try {
      var response = await _orderService.addToCart(oid);
      c.complete(response.statusCode);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<int> minusFromCart(String oid) async {
    var c = Completer<int>();
    try {
      var response = await _orderService.minusFromCart(oid);
      c.complete(response.statusCode);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<int> confirmOrder() async {
    var c = Completer<int>();
    try {
      var response = await _orderService.confirmOrder();
      var status = response.data['status'];
      print(response.data);
      c.complete(status);
    } on DioError{
      var map = {'status':'404'};
     c.completeError(map);
    } catch (e) {
      print(e);
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<Revenue>> getRevenues(String month) async {
    var c = Completer<List<Revenue>>();
    try {
      var response = await _orderService.getRevenue(month);
      var list = Revenue.parseRevenueList(response.data);
      c.complete(list);
    } on DioError {
//      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

}
