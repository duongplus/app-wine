import 'package:dio/dio.dart';
import 'package:wine_app/network/wine_client.dart';

class OrderService{
  Future<Response> countShoppingCart() {
    return WineClient.instance.dio.get(
      '/api/order/count',
    );
  }

  Future<Response> getShoppingCart() {
    return WineClient.instance.dio.get(
      '/api/order/shopping-cart',
    );
  }

  Future<Response> addToCart(String oid) {
    return WineClient.instance.dio.post(
      '/api/order/add-to-cart/$oid',
    );
  }

  Future<Response> minusFromCart(String oid) {
    return WineClient.instance.dio.post(
      '/api/order/minus-from-cart/$oid',
    );
  }

  Future<Response> confirmOrder() {
    return WineClient.instance.dio.post(
      '/api/order/checkout',
    );
  }

  Future<Response> getRevenue(String month) {
    return WineClient.instance.dio.get(
      '/api/order/statistic/$month',
    );
  }

}