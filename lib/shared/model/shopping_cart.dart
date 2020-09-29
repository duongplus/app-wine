import 'package:wine_app/shared/model/wine.dart';

class ShoppingCart {
  Wine wine;
  int amount;

  ShoppingCart({this.wine, this.amount});

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
        wine: Wine.fromJson(json['wine']) ?? '',
        amount: json["amount"] ?? 0,
      );

  static List<ShoppingCart> parseShoppingCartList(map) {
    var wines = map['data']['wines'];
    List<ShoppingCart> list = List<ShoppingCart>();
    for(var i=0; i<wines.length;i++ ){
      list.add(
        ShoppingCart(
          wine: Wine.fromJson(wines[i]["orderInfo"]["wine"]),
          amount: wines[i]["orderInfo"]["amount"],
        )
      );
    }
    return list;
  }
}
