import 'package:dio/dio.dart';
import 'package:wine_app/network/wine_client.dart';
import 'package:wine_app/shared/model/wine.dart';

class WineService{
  Future<Response> getWineList() {
    return WineClient.instance.dio.get(
      '/api/wine/list',
    );
  }

  Future<Response> getWines() {
    return WineClient.instance.dio.get(
      '/api/wine/all-wine',
    );
  }

  Future<Response> getWinesByCateId(String cateId) {
    return WineClient.instance.dio.get(
      '/api/wine/cate/$cateId',
    );
  }

  Future<Response> profileUser() {
    return WineClient.instance.dio.get(
      '/api/user/profile',
    );
  }

  Future<Response> updateWine(Wine wine) {
    return WineClient.instance.dio.post(
      '/api/wine/update/${wine.id['\$oid']}',
      data: {
        "name":wine.name,
        "producer": wine.producer,
        "country": wine.country,
        "alcohol": wine.alcohol,
        "description": wine.description,
        "thumbnail": wine.thumbnail,
        "price": wine.price,
        "cateID": wine.cateId,
        "capacity": wine.capacity,
        "size": wine.size
      }
    );
  }

  Future<Response> addWine(Wine wine) {
    return WineClient.instance.dio.post(
        '/api/wine/add',
        data: {
          "name":wine.name,
          "producer": wine.producer,
          "country": wine.country,
          "alcohol": wine.alcohol,
          "description": wine.description,
          "thumbnail": wine.thumbnail,
          "price": wine.price,
          "cateID": wine.cateId,
          "capacity": wine.capacity,
          "size": wine.size
        }
    );
  }

  Future<Response> deleteWine(String wineId) {
    return WineClient.instance.dio.post(
      '/api/wine/delete/$wineId',
    );
  }
}