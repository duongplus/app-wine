import 'package:wine_app/shared/model/shopping_cart.dart';
import 'package:wine_app/shared/model/wine.dart';

class Revenue{
  dynamic phone;
  dynamic total;
  dynamic percentDiscount;
  dynamic discount;
  dynamic netTotal;
  dynamic date;
  dynamic status;
  List<ShoppingCart> wines;

  Revenue({this.phone, this.total, this.percentDiscount, this.discount,
    this.netTotal, this.date, this.status, this.wines});

  factory Revenue.fromJson(Map<String, dynamic> map){

    var r = Revenue(
      phone: map['phone'],
      total: map['total'],
      percentDiscount: map['percentDiscount'],
      discount: map['discount'],
      netTotal: map['netTotal'],
      date: map['date'],
      status: map['status'],
      wines: List<ShoppingCart>(),
    );
    var wines = map['wines'];
    for(var i=0; i<wines.length;i++ ){
      r.wines.add(
          ShoppingCart(
            wine: Wine.fromJson(wines[i]["orderInfo"]["wine"]),
            amount: wines[i]["orderInfo"]["amount"],
          )
      );
    }
    return r;
  }

  static List<Revenue> parseRevenueList(map) {
    var list = map['data']['order'] as List;
    return list.map((product) => Revenue.fromJson(product)).toList();
  }

  static List<Revenue> parseUserHistory(map) {
    var list = map['data'] as List;
    return list.map((product) => Revenue.fromJson(product)).toList();
  }
}